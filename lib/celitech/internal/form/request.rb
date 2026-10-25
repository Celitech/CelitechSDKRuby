# frozen_string_literal: true

# Both reach the rest of the internal runtime transitively -- `URI` through `net/http`, `JSON`
# through the serializers -- and are required explicitly here because this file uses them
# directly: `encode_www_form` is its whole encoder, and `JSON.generate` renders non-scalar leaves.
require 'json'
require 'uri'

module Celitech
  module Internal
    module Form
      # A request whose body is a STRUCTURED value sent as `application/x-www-form-urlencoded`.
      #
      # FSDK-1441 routed a declared non-JSON body to `Internal::Raw::Request` only when its schema
      # was a string or binary, because those travel verbatim. A urlencoded body's schema is an
      # OBJECT, so it stayed on `Internal::JSON::Request` — which `JSON.generate`s it and labels it
      # `application/json`. The server was told the wrong media type and handed a JSON document
      # where it asked for form fields (FSDK-1668).
      #
      # @api private
      class Request < ::Celitech::Internal::Http::BaseRequest
        CONTENT_TYPE = 'application/x-www-form-urlencoded'

        attr_reader :body

        # @param base_url [String] The base URL for the request
        # @param path [String] The path for the request
        # @param method [Symbol] The HTTP method for the request (:get, :post, etc.)
        # @param headers [Hash] Additional headers for the request (optional)
        # @param query [Hash] Query parameters for the request (optional)
        # @param body [Hash, nil] The request body as the model's wire hash (optional)
        # @param content_type [String] The media type declared for the request body.
        # @param accept [String] The media type declared for the response body.
        # @param request_options [::Celitech::RequestOptions, Hash{Symbol=>Object}, nil]
        def initialize(base_url:, path:, method:, headers: {}, query: {}, body: nil, content_type: CONTENT_TYPE, accept: '*/*', request_options: {})
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
        # MEMOISED for the same reason as the raw and multipart encoders: `RawClient#send` calls
        # this once per attempt, so a retry must replay the bytes rather than re-derive them.
        def encode_body
          return nil if @body.nil?
          # The memo is named after the METHOD rather than after the value it holds, which is the
          # naming convention the generated .rubocop.yml enforces.
          return @encode_body if defined?(@encode_body)

          @encode_body =
            if @body.is_a?(::Hash)
              ::URI.encode_www_form(form_fields)
            else
              # A oneOf/anyOf body can resolve to a bare scalar or an array rather than an object,
              # and a form field has no name to hang one of those on. Passed through as its own
              # text, which is what the raw path does for a urlencoded body declared as a string.
              # Tested with +is_a?(::Hash)+ rather than +respond_to?(:to_h)+ because +Array#to_h+
              # EXISTS and raises TypeError on a non-pair array.
              @body.to_s
            end
        end

        private

        # The model's wire hash flattened to the `[key, value]` pairs `URI.encode_www_form` is
        # defined over, under the OpenAPI default for a urlencoded body (`form`, `explode: true`).
        #
        # An ARRAY becomes one repeated key per element, which is what `explode: true` means; it is
        # expanded here rather than left to `encode_www_form`'s own array handling so an array of
        # non-scalars gets the JSON leaf treatment below instead of `Array#to_s`.
        #
        # A nil value is OMITTED. `application/x-www-form-urlencoded` has no null, so the only
        # alternatives are dropping the field or asserting an empty string for it, and an empty
        # string is a different value the caller did not send.
        def form_fields
          @body.each_with_object([]) do |(key, value), pairs|
            next if value.nil?

            if value.is_a?(::Array)
              value.each { |element| pairs << [key.to_s, form_value(element)] }
            else
              pairs << [key.to_s, form_value(value)]
            end
          end
        end

        # A form field is a scalar. OpenAPI says nothing about what a nested object or array leaf
        # looks like inside a urlencoded body, so JSON is emitted for it — the caller's data
        # survives, rather than Ruby's `Hash#to_s` / `Array#to_s` rendering reaching the wire.
        def form_value(value)
          value.is_a?(::Hash) || value.is_a?(::Array) ? ::JSON.generate(value) : value.to_s
        end
      end
    end
  end
end
