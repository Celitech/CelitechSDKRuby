# frozen_string_literal: true

require 'uri'

module Celitech
  module Purchases
    class Client
      def initialize(client:)
        @client = client
      end

      # This endpoint is used to purchase a new eSIM by providing the package details.
      def create_purchase_v2(request_options: {}, **params)
        params = ::Celitech::Internal::Types::Utils.normalize_keys(params)
        headers = {}
        headers['Idempotency-Key'] = ::Celitech::Internal::Types::Utils.simple_param(params[:idempotency_key]) if params.key?(:idempotency_key)
        request_body = ::Celitech::Purchases::Types::CreatePurchaseV2Request.new(params.except(:idempotency_key))
        request_body.validate! if request_body.respond_to?(:validate!)
        request = ::Celitech::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: 'POST',
          path: 'purchases/v2',
          body: request_body.to_h,
          headers: headers,
          request_options: request_options,
        )
        response = @client.send(request)
        code = response.code.to_i
        if code.between?(200, 299)
          result = ::Celitech::Internal::Http::ResponseBody.decode(response) { |body| ::Celitech::Internal::Types::Array[::Celitech::Purchases::Types::CreatePurchaseV2ResponseItem].coerce(::JSON.parse(body, symbolize_names: false)) }
          result&.each { |item| item.validate! if item.respond_to?(:validate!) }
          result
        else
          error_class = ::Celitech::Errors::ResponseError.subclass_for_code(code)
          error_body = ::Celitech::Errors::ResponseError.load_body(response.body, { 400 => ::Celitech::Types::ErrorResponse, 401 => ::Celitech::Types::ErrorResponse, 409 => ::Celitech::Types::ErrorResponse, 422 => ::Celitech::Types::ErrorResponse, 503 => ::Celitech::Types::ErrorResponse }[code])
          raise error_class.new(response.body, code: code, body: error_body)
        end
      end

      # This endpoint can be used to list all the successful purchases made between a given interval.
      def list_purchases(request_options: {}, **params)
        params = ::Celitech::Internal::Types::Utils.normalize_keys(params)
        query_params = {}
        query_params['purchaseId'] = params[:purchase_id] if params.key?(:purchase_id)
        query_params['iccid'] = params[:iccid] if params.key?(:iccid)
        query_params['afterDate'] = params[:after_date] if params.key?(:after_date)
        query_params['beforeDate'] = params[:before_date] if params.key?(:before_date)
        query_params['email'] = params[:email] if params.key?(:email)
        query_params['referenceId'] = params[:reference_id] if params.key?(:reference_id)
        query_params['afterCursor'] = params[:after_cursor] if params.key?(:after_cursor)
        query_params['limit'] = params[:limit] if params.key?(:limit)
        query_params['after'] = params[:after] if params.key?(:after)
        query_params['before'] = params[:before] if params.key?(:before)
        request = ::Celitech::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: 'GET',
          path: 'purchases',
          query: query_params,
          request_options: request_options,
        )
        response = @client.send(request)
        code = response.code.to_i
        if code.between?(200, 299)
          result = ::Celitech::Internal::Http::ResponseBody.decode(response) { |body| ::Celitech::Purchases::Types::ListPurchasesResponse.load(body) }
          result.validate! if result.respond_to?(:validate!)
          result
        else
          error_class = ::Celitech::Errors::ResponseError.subclass_for_code(code)
          error_body = ::Celitech::Errors::ResponseError.load_body(response.body, { 400 => ::Celitech::Types::ErrorResponse, 401 => ::Celitech::Types::ErrorResponse, 409 => ::Celitech::Types::ErrorResponse, 422 => ::Celitech::Types::ErrorResponse, 503 => ::Celitech::Types::ErrorResponse }[code])
          raise error_class.new(response.body, code: code, body: error_body)
        end
      end

      # This endpoint is used to purchase a new eSIM by providing the package details.
      # @deprecated
      def create_purchase(request_options: {}, **params)
        params = ::Celitech::Internal::Types::Utils.normalize_keys(params)
        headers = {}
        headers['Idempotency-Key'] = ::Celitech::Internal::Types::Utils.simple_param(params[:idempotency_key]) if params.key?(:idempotency_key)
        request_body = ::Celitech::Purchases::Types::CreatePurchaseRequest.new(params.except(:idempotency_key))
        request_body.validate! if request_body.respond_to?(:validate!)
        request = ::Celitech::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: 'POST',
          path: 'purchases',
          body: request_body.to_h,
          headers: headers,
          request_options: request_options,
        )
        response = @client.send(request)
        code = response.code.to_i
        if code.between?(200, 299)
          result = ::Celitech::Internal::Http::ResponseBody.decode(response) { |body| ::Celitech::Purchases::Types::CreatePurchaseResponse.load(body) }
          result.validate! if result.respond_to?(:validate!)
          result
        else
          error_class = ::Celitech::Errors::ResponseError.subclass_for_code(code)
          error_body = ::Celitech::Errors::ResponseError.load_body(response.body, { 400 => ::Celitech::Types::ErrorResponse, 401 => ::Celitech::Types::ErrorResponse, 409 => ::Celitech::Types::ErrorResponse, 422 => ::Celitech::Types::ErrorResponse, 503 => ::Celitech::Types::ErrorResponse }[code])
          raise error_class.new(response.body, code: code, body: error_body)
        end
      end

      # This endpoint is used to top-up an existing eSIM with the previously associated destination by providing its ICCID and package details. To determine if an eSIM can be topped up, use the Get eSIM endpoint, which returns the `isTopUpAllowed` flag.
      def top_up_esim(request_options: {}, **params)
        params = ::Celitech::Internal::Types::Utils.normalize_keys(params)
        headers = {}
        headers['Idempotency-Key'] = ::Celitech::Internal::Types::Utils.simple_param(params[:idempotency_key]) if params.key?(:idempotency_key)
        request_body = ::Celitech::Purchases::Types::TopUpEsimRequest.new(params.except(:idempotency_key))
        request_body.validate! if request_body.respond_to?(:validate!)
        request = ::Celitech::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: 'POST',
          path: 'purchases/topup',
          body: request_body.to_h,
          headers: headers,
          request_options: request_options,
        )
        response = @client.send(request)
        code = response.code.to_i
        if code.between?(200, 299)
          result = ::Celitech::Internal::Http::ResponseBody.decode(response) { |body| ::Celitech::Purchases::Types::TopUpEsimResponse.load(body) }
          result.validate! if result.respond_to?(:validate!)
          result
        else
          error_class = ::Celitech::Errors::ResponseError.subclass_for_code(code)
          error_body = ::Celitech::Errors::ResponseError.load_body(response.body, { 400 => ::Celitech::Types::ErrorResponse, 401 => ::Celitech::Types::ErrorResponse, 409 => ::Celitech::Types::ErrorResponse, 422 => ::Celitech::Types::ErrorResponse, 503 => ::Celitech::Types::ErrorResponse }[code])
          raise error_class.new(response.body, code: code, body: error_body)
        end
      end

      # This endpoint allows you to modify the validity dates of an existing purchase.
      #
      # **Behavior:**
      # - If the purchase has **not yet been activated**, both the start and end dates can be updated.
      # - If the purchase is **already active**, only the **end date** can be updated, while the **start date must remain unchanged** (and should be passed as originally set).
      # - Updates must comply with the same pricing structure; the modification cannot alter the package size or change its duration category.
      #
      # The end date can be extended or shortened as long as it adheres to the same pricing category and does not exceed the allowed duration limits.
      def edit_purchase(request_options: {}, **params)
        params = ::Celitech::Internal::Types::Utils.normalize_keys(params)
        headers = {}
        headers['Idempotency-Key'] = ::Celitech::Internal::Types::Utils.simple_param(params[:idempotency_key]) if params.key?(:idempotency_key)
        request_body = ::Celitech::Purchases::Types::EditPurchaseRequest.new(params.except(:idempotency_key))
        request_body.validate! if request_body.respond_to?(:validate!)
        request = ::Celitech::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: 'POST',
          path: 'purchases/edit',
          body: request_body.to_h,
          headers: headers,
          request_options: request_options,
        )
        response = @client.send(request)
        code = response.code.to_i
        if code.between?(200, 299)
          result = ::Celitech::Internal::Http::ResponseBody.decode(response) { |body| ::Celitech::Purchases::Types::EditPurchaseResponse.load(body) }
          result.validate! if result.respond_to?(:validate!)
          result
        else
          error_class = ::Celitech::Errors::ResponseError.subclass_for_code(code)
          error_body = ::Celitech::Errors::ResponseError.load_body(response.body, { 400 => ::Celitech::Types::ErrorResponse, 401 => ::Celitech::Types::ErrorResponse, 409 => ::Celitech::Types::ErrorResponse, 422 => ::Celitech::Types::ErrorResponse, 503 => ::Celitech::Types::ErrorResponse }[code])
          raise error_class.new(response.body, code: code, body: error_body)
        end
      end

      # This endpoint can be called for consumption notifications (e.g. every 1 hour or when the user clicks a button). It returns the data balance (consumption) of purchased packages.
      def get_purchase_consumption(request_options: {}, **params)
        params = ::Celitech::Internal::Types::Utils.normalize_keys(params)
        request = ::Celitech::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: 'GET',
          path: "purchases/#{URI.encode_uri_component(params[:purchase_id].to_s)}/consumption",
          request_options: request_options,
        )
        response = @client.send(request)
        code = response.code.to_i
        if code.between?(200, 299)
          result = ::Celitech::Internal::Http::ResponseBody.decode(response) { |body| ::Celitech::Purchases::Types::GetPurchaseConsumptionResponse.load(body) }
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
