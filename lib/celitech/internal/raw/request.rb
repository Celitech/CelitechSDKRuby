# frozen_string_literal: true

module Celitech
  module Internal
    module Raw
      # A request whose body is sent to the server exactly as the caller supplied it.
      #
      # `Internal::JSON::Request` is the wrong carrier for a declared non-JSON body: `encode_body`
      # runs `::JSON.generate`, which turns a `text/plain` string into a quoted JSON string
      # (`"hello"` on the wire, not `hello`) and RAISES on binary bytes
      # (`Encoding::UndefinedConversionError`) — so an `application/octet-stream` upload failed
      # inside the SDK's own encoder before it ever reached the network. With the body left
      # untouched here, the declared media type in `Content-Type` is finally the truth about what
      # was sent, which is what let FSDK-1442 stop defaulting a non-JSON type to `application/json`.
      #
      # @api private
      class Request < ::Celitech::Internal::Http::BaseRequest
        attr_reader :body

        # @param base_url [String] The base URL for the request
        # @param path [String] The path for the request
        # @param method [Symbol] The HTTP method for the request (:get, :post, etc.)
        # @param headers [Hash] Additional headers for the request (optional)
        # @param query [Hash] Query parameters for the request (optional)
        # @param body [String, #read, nil] The raw request body (optional)
        # @param content_type [String] The media type declared for the request body.
        # @param accept [String] The media type declared for the response body.
        # @param request_options [::Celitech::RequestOptions, Hash{Symbol=>Object}, nil]
        def initialize(base_url:, path:, method:, headers: {}, query: {}, body: nil, content_type: 'application/octet-stream', accept: '*/*', request_options: {})
          super(base_url:, path:, method:, headers:, query:, request_options:)

          @body = body
          @content_type = content_type
          @accept = accept
        end

        # @return [Hash] The encoded HTTP request headers.
        # @param protected_keys [Array<String>] Header keys set by the SDK client (e.g. auth, metadata)
        #   that must not be overridden by additional_headers from request_options.
        def encode_headers(protected_keys: [])
          sdk_headers = {
            'Content-Type' => @content_type,
            'Accept' => @accept,
          }.merge(@headers)
          merge_additional_headers(sdk_headers, protected_keys:)
        end

        # @return [String, nil] The encoded HTTP request body.
        #
        # An IO/File is READ rather than `to_s`-ed, because `File#to_s` is
        # `"#<File:0x000...>"` — the object's inspect output, not its bytes. `binmode` first so the
        # bytes arrive as ASCII-8BIT: a `File.open(path)` defaults to the external encoding, and a
        # UTF-8-tagged string holding invalid UTF-8 raises when concatenated downstream.
        # MEMOISED, because `RawClient#send` calls this once per attempt and an IO can only be
        # drained once: on a retry the handle already sits at EOF, so attempt 2 read `nil`/`""` and
        # the SDK uploaded an EMPTY body while reporting success. Reading once and replaying the
        # bytes is what makes a raw upload survive a retry. `rewind` additionally covers a handle
        # that arrives already partly consumed; a non-seekable IO (a pipe) refuses it, which is
        # harmless here since it is read exactly once anyway.
        def encode_body
          return nil if @body.nil?
          # The memo is named after the METHOD rather than after the value it holds, which is the
          # naming convention the generated .rubocop.yml enforces.
          return @encode_body if defined?(@encode_body)

          @encode_body =
            if @body.respond_to?(:read)
              @body.binmode if @body.respond_to?(:binmode)
              rewind_body
              @body.read
            elsif @body.is_a?(::String)
              @body
            else
              @body.to_s
            end
        end

        private

        def rewind_body
          @body.rewind if @body.respond_to?(:rewind)
        rescue ::IOError, ::SystemCallError
          nil
        end
      end
    end
  end
end
