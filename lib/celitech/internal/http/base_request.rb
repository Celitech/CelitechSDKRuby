# frozen_string_literal: true

module Celitech
  module Internal
    module Http
      # @api private
      class BaseRequest
        attr_reader :base_url, :path, :method, :headers, :query, :request_options

        # @param base_url [String] The base URL for the request
        # @param path [String] The path for the request
        # @param method [String] The HTTP method for the request (:get, :post, etc.)
        # @param headers [Hash] Additional headers for the request (optional)
        # @param query [Hash] Query parameters for the request (optional)
        # @param request_options [::Celitech::RequestOptions, Hash{Symbol=>Object}, nil]
        def initialize(base_url:, path:, method:, headers: {}, query: {}, request_options: {})
          @base_url = base_url
          @path = path
          @method = method
          @headers = headers
          @query = query
          @request_options = request_options
        end

        # The query parameters merged with additional query parameters from request options.
        #
        # A service passes +query+ as a Hash when every declared parameter is a default-style
        # (form + explode) scalar or flat array, which +URI.encode_www_form+ already serializes
        # correctly. When any parameter declares another style — spaceDelimited, pipeDelimited,
        # deepObject, explode: false — or carries an object, the service passes an Array of
        # already-encoded "key=value" parts instead, because those forms cannot be expressed as a
        # Hash that +encode_www_form+ would render right. Both shapes are carried through to
        # +RawClient#encode_query+, which joins an Array and form-encodes a Hash.
        #
        # @return [Hash, Array<String>] The merged query parameters.
        def encode_query
          additional_query = @request_options&.dig(:additional_query_parameters) || @request_options&.dig('additional_query_parameters') || {}
          return @query.merge(additional_query) unless @query.is_a?(::Array)

          # Braces, not do/end: `do` would bind to `+` rather than to `flat_map`.
          @query + additional_query.flat_map { |key, value| ::Celitech::Serializers::Params.query_part(key.to_s, value) }
        end

        # Child classes should implement:
        # - encode_headers: Returns the encoded HTTP request headers.
        # - encode_body: Returns the encoded HTTP request body.

        private

        # Merges additional_headers from request_options into sdk_headers, filtering out
        # any keys that collide with SDK-set or client-protected headers (case-insensitive).
        # @param sdk_headers [Hash] Headers set by the SDK for this request type.
        # @param protected_keys [Array<String>] Additional header keys that must not be overridden.
        # @return [Hash] The merged headers.
        def merge_additional_headers(sdk_headers, protected_keys: [])
          additional_headers = @request_options&.dig(:additional_headers) || @request_options&.dig('additional_headers') || {}
          all_protected = (sdk_headers.keys + protected_keys).to_set { |k| k.to_s.downcase }
          filtered = additional_headers.reject { |key, _| all_protected.include?(key.to_s.downcase) }
          sdk_headers.merge(filtered)
        end
      end
    end
  end
end
