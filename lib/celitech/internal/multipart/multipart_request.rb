# frozen_string_literal: true

module Celitech
  module Internal
    module Multipart
      # @api private
      class Request < ::Celitech::Internal::Http::BaseRequest
        attr_reader :body

        # @param base_url [String] The base URL for the request
        # @param path [String] The path for the request
        # @param method [Symbol] The HTTP method for the request (:get, :post, etc.)
        # @param headers [Hash] Additional headers for the request (optional)
        # @param query [Hash] Query parameters for the request (optional)
        # @param body [MultipartFormData, nil] The multipart form data for the request (optional)
        # @param request_options [::Celitech::RequestOptions, Hash{Symbol=>Object}, nil]
        def initialize(base_url:, path:, method:, headers: {}, query: {}, body: nil, request_options: {})
          super(base_url:, path:, method:, headers:, query:, request_options:)

          @body = body
        end

        # @return [Hash] The encoded HTTP request headers.
        # @param protected_keys [Array<String>] Header keys set by the SDK client (e.g. auth, metadata)
        #   that must not be overridden by additional_headers from request_options.
        def encode_headers(protected_keys: [])
          sdk_headers = {
            'Content-Type' => @body.content_type,
          }.merge(@headers)
          merge_additional_headers(sdk_headers, protected_keys:)
        end

        # @return [String, nil] The encoded HTTP request body.
        #
        # MEMOISED for the same reason as `Raw::Request#encode_body`: `RawClient#send` encodes once
        # per attempt, and `MultipartEncoder#close` marks the encoder closed — so a second `encode`
        # raised `RuntimeError: Cannot write to closed encoder`. A retried multipart upload (a POST
        # carrying an idempotency key) therefore died inside the SDK instead of being replayed.
        def encode_body
          # The memo is named after the METHOD rather than after the value it holds, which is the
          # naming convention the generated .rubocop.yml enforces.
          return @encode_body if defined?(@encode_body)

          @encode_body = @body&.encode
        end
      end
    end
  end
end
