# frozen_string_literal: true

module Celitech
  module Destinations
    class Client
      def initialize(client:)
        @client = client
      end

      # List Destinations
      def list_destinations(request_options: {}, **params)
        request = ::Celitech::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: 'GET',
          path: 'destinations',
          request_options: request_options,
        )
        response = @client.send(request)
        code = response.code.to_i
        if code.between?(200, 299)
          result = ::Celitech::Internal::Http::ResponseBody.decode(response) { |body| ::Celitech::Destinations::Types::ListDestinationsResponse.load(body) }
          result.validate! if result.respond_to?(:validate!)
          result
        else
          error_class = ::Celitech::Errors::ResponseError.subclass_for_code(code)
          error_body = ::Celitech::Errors::ResponseError.load_body(response.body, { 400 => ::Celitech::Types::ErrorResponse, 401 => ::Celitech::Types::ErrorResponse, 409 => ::Celitech::Types::ErrorResponse, 422 => ::Celitech::Types::ErrorResponse, 503 => ::Celitech::Types::ErrorResponse }[code])
          raise error_class.new(response.body, code: code, body: error_body)
        end
      end
    end
  end
end
