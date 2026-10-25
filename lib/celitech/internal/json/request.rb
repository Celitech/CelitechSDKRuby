# frozen_string_literal: true

module Celitech
  module Internal
    module JSON
      # @api private
      class Request < ::Celitech::Internal::Http::BaseRequest
        attr_reader :body

        # @param base_url [String] The base URL for the request
        # @param path [String] The path for the request
        # @param method [Symbol] The HTTP method for the request (:get, :post, etc.)
        # @param headers [Hash] Additional headers for the request (optional)
        # @param query [Hash] Query parameters for the request (optional)
        # @param body [Object, nil] The JSON request body (optional)
        # @param content_type [String] The media type declared for the request body. JSON-family
        #   types are not interchangeable: `application/merge-patch+json` selects merge-patch
        #   semantics, and sending `application/json` instead changes what the server does.
        # @param accept [String] The media type declared for the RESPONSE body. A server that
        #   content-negotiates on Accept can 406 a request that asks for the wrong one, so an
        #   endpoint returning `application/vnd.api+json` has to say so.
        # @param request_options [::Celitech::RequestOptions, Hash{Symbol=>Object}, nil]
        def initialize(base_url:, path:, method:, headers: {}, query: {}, body: nil, content_type: 'application/json', accept: 'application/json', request_options: {})
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
        # `additional_body_parameters` from request_options is the per-request escape hatch for
        # sending undocumented or beta fields without a new SDK version. It is shallow-merged onto
        # an object body with the extras winning, so an extra key named like a declared field
        # replaces it. A nil body becomes the extras; an array or primitive body has no object to
        # merge onto and is sent unchanged. Keys are stringified because a model's `#to_h` is keyed
        # by wire name (a String) and a Symbol key would otherwise emit the field twice.
        def encode_body
          extra = @request_options&.dig(:additional_body_parameters) || @request_options&.dig('additional_body_parameters')
          return @body.nil? ? nil : ::JSON.generate(@body) unless extra.is_a?(::Hash) && !extra.empty?
          return ::JSON.generate(extra.transform_keys(&:to_s)) if @body.nil?
          return ::JSON.generate(@body) unless @body.is_a?(::Hash)

          ::JSON.generate(@body.merge(extra.transform_keys(&:to_s)))
        end
      end
    end
  end
end
