# frozen_string_literal: true

module Celitech
  module OAuth
    class Client
      def initialize(client:)
        @client = client
      end

      def get_access_token(request_options: {}, **params)
        params = ::Celitech::Internal::Types::Utils.normalize_keys(params)
        request_body = ::Celitech::OAuth::Types::GetAccessTokenRequest.new(params)
        request_body.validate! if request_body.respond_to?(:validate!)
        request = ::Celitech::Internal::Form::Request.new(
          base_url: request_options[:base_url],
          method: 'POST',
          path: 'oauth2/token',
          body: request_body.to_h,
          accept: 'application/json',
          request_options: request_options,
        )
        response = @client.send(request)
        code = response.code.to_i
        if code.between?(200, 299)
          result = ::Celitech::Internal::Http::ResponseBody.decode(response) { |body| ::Celitech::OAuth::Types::GetAccessTokenResponse.load(body) }
          result.validate! if result.respond_to?(:validate!)
          result
        else
          error_class = ::Celitech::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end
    end
  end
end
