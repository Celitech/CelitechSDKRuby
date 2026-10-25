# frozen_string_literal: true

module Celitech
  module Packages
    class Client
      def initialize(client:)
        @client = client
      end

      # List Packages
      def list_packages(request_options: {}, **params)
        params = ::Celitech::Internal::Types::Utils.normalize_keys(params)
        query_params = {}
        query_params['destination'] = params[:destination] if params.key?(:destination)
        query_params['dataLimitInGB'] = params[:data_limit_in_gb] if params.key?(:data_limit_in_gb)
        query_params['startDate'] = params[:start_date] if params.key?(:start_date)
        query_params['endDate'] = params[:end_date] if params.key?(:end_date)
        query_params['afterCursor'] = params[:after_cursor] if params.key?(:after_cursor)
        query_params['limit'] = params[:limit] if params.key?(:limit)
        query_params['startTime'] = params[:start_time] if params.key?(:start_time)
        query_params['endTime'] = params[:end_time] if params.key?(:end_time)
        query_params['includeUnlimited'] = params[:include_unlimited] if params.key?(:include_unlimited)
        request = ::Celitech::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: 'GET',
          path: 'packages',
          query: query_params,
          request_options: request_options,
        )
        response = @client.send(request)
        code = response.code.to_i
        if code.between?(200, 299)
          result = ::Celitech::Internal::Http::ResponseBody.decode(response) { |body| ::Celitech::Packages::Types::ListPackagesResponse.load(body) }
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
