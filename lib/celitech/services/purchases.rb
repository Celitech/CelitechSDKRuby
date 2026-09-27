# frozen_string_literal: true

module Celitech
  class Purchases
    NO_OVERRIDE = Object.new.freeze
    private_constant :NO_OVERRIDE

    def initialize(connection, config = nil, token_manager: nil)
      @connection = connection
      @config = config
      @token_manager = token_manager
    end

    # Create Purchase V2
    def create_purchase_v2(body:, config: NO_OVERRIDE)
      headers = config_headers(config).merge(resolve_config(config)&.additional_headers || {})
      body.validate! if body.respond_to?(:validate!)
      conn = resolve_connection(config)
      response = conn.post('/purchases/v2', body, headers: headers)
      return response if !config.equal?(NO_OVERRIDE) && config&.return_raw
      result = response.body.map { |item| ::Celitech::Models::CreatePurchaseV2OkResponse.from_hash(item) }
      result&.each { |item| item&.validate! } if resolve_config(config)&.enable_response_validation
      result
    rescue APIError => e
      case e.status
      when 400
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::BadRequest.from_hash(e.body) : nil
        raise ::Celitech::BadRequestError.new(e.status, parsed, e.body, e.headers)
      when 401
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::Unauthorized.from_hash(e.body) : nil
        raise ::Celitech::UnauthorizedError.new(e.status, parsed, e.body, e.headers)
      end
      raise
    end

    # List Purchases
    def list_purchases(
      purchase_id: nil,
      iccid: nil,
      after_date: nil,
      before_date: nil,
      email: nil,
      reference_id: nil,
      after_cursor: nil,
      limit: nil,
      after: nil,
      before: nil,
      config: NO_OVERRIDE
    )
      query_params = {
        'purchaseId' => purchase_id,
        'iccid' => iccid,
        'afterDate' => after_date,
        'beforeDate' => before_date,
        'email' => email,
        'referenceId' => reference_id,
        'afterCursor' => after_cursor,
        'limit' => limit,
        'after' => after,
        'before' => before,
      }.compact
      query_params = query_params.merge(resolve_config(config)&.additional_query_parameters || {})
      headers = config_headers(config).merge(resolve_config(config)&.additional_headers || {})
      Validator.validate_string!(iccid, 'iccid', min_length: 18, max_length: 22)
      conn = resolve_connection(config)
      response = conn.get('/purchases', query_params, headers)
      return response if !config.equal?(NO_OVERRIDE) && config&.return_raw
      result = ::Celitech::Models::ListPurchasesOkResponse.from_hash(response.body)
      result&.validate! if resolve_config(config)&.enable_response_validation
      result
    rescue APIError => e
      case e.status
      when 400
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::BadRequest.from_hash(e.body) : nil
        raise ::Celitech::BadRequestError.new(e.status, parsed, e.body, e.headers)
      when 401
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::Unauthorized.from_hash(e.body) : nil
        raise ::Celitech::UnauthorizedError.new(e.status, parsed, e.body, e.headers)
      end
      raise
    end

    # Create Purchase
    # @deprecated
    def create_purchase(body:, config: NO_OVERRIDE)
      headers = config_headers(config).merge(resolve_config(config)&.additional_headers || {})
      body.validate! if body.respond_to?(:validate!)
      conn = resolve_connection(config)
      response = conn.post('/purchases', body, headers: headers)
      return response if !config.equal?(NO_OVERRIDE) && config&.return_raw
      result = ::Celitech::Models::CreatePurchaseOkResponse.from_hash(response.body)
      result&.validate! if resolve_config(config)&.enable_response_validation
      result
    rescue APIError => e
      case e.status
      when 400
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::BadRequest.from_hash(e.body) : nil
        raise ::Celitech::BadRequestError.new(e.status, parsed, e.body, e.headers)
      when 401
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::Unauthorized.from_hash(e.body) : nil
        raise ::Celitech::UnauthorizedError.new(e.status, parsed, e.body, e.headers)
      end
      raise
    end

    # Top-up eSIM
    def top_up_esim(body:, config: NO_OVERRIDE)
      headers = config_headers(config).merge(resolve_config(config)&.additional_headers || {})
      body.validate! if body.respond_to?(:validate!)
      conn = resolve_connection(config)
      response = conn.post('/purchases/topup', body, headers: headers)
      return response if !config.equal?(NO_OVERRIDE) && config&.return_raw
      result = ::Celitech::Models::TopUpEsimOkResponse.from_hash(response.body)
      result&.validate! if resolve_config(config)&.enable_response_validation
      result
    rescue APIError => e
      case e.status
      when 400
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::BadRequest.from_hash(e.body) : nil
        raise ::Celitech::BadRequestError.new(e.status, parsed, e.body, e.headers)
      when 401
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::Unauthorized.from_hash(e.body) : nil
        raise ::Celitech::UnauthorizedError.new(e.status, parsed, e.body, e.headers)
      end
      raise
    end

    # Edit Purchase
    def edit_purchase(body:, config: NO_OVERRIDE)
      headers = config_headers(config).merge(resolve_config(config)&.additional_headers || {})
      body.validate! if body.respond_to?(:validate!)
      conn = resolve_connection(config)
      response = conn.post('/purchases/edit', body, headers: headers)
      return response if !config.equal?(NO_OVERRIDE) && config&.return_raw
      result = ::Celitech::Models::EditPurchaseOkResponse.from_hash(response.body)
      result&.validate! if resolve_config(config)&.enable_response_validation
      result
    rescue APIError => e
      case e.status
      when 400
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::BadRequest.from_hash(e.body) : nil
        raise ::Celitech::BadRequestError.new(e.status, parsed, e.body, e.headers)
      when 401
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::Unauthorized.from_hash(e.body) : nil
        raise ::Celitech::UnauthorizedError.new(e.status, parsed, e.body, e.headers)
      end
      raise
    end

    # Get Purchase Consumption
    def get_purchase_consumption(purchase_id:, config: NO_OVERRIDE)
      headers = config_headers(config).merge(resolve_config(config)&.additional_headers || {})
      conn = resolve_connection(config)
      url = "/purchases/#{Serializers::Params.simple(purchase_id, explode: false)}/consumption"
      response = conn.get(url, {}, headers)
      return response if !config.equal?(NO_OVERRIDE) && config&.return_raw
      result = ::Celitech::Models::GetPurchaseConsumptionOkResponse.from_hash(response.body)
      result&.validate! if resolve_config(config)&.enable_response_validation
      result
    rescue APIError => e
      case e.status
      when 400
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::BadRequest.from_hash(e.body) : nil
        raise ::Celitech::BadRequestError.new(e.status, parsed, e.body, e.headers)
      when 401
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::Unauthorized.from_hash(e.body) : nil
        raise ::Celitech::UnauthorizedError.new(e.status, parsed, e.body, e.headers)
      end
      raise
    end

    private

    def config_headers(_override_config)
      return {} unless @token_manager

      @token_manager.headers
    end

    def resolve_connection(override_config)
      cfg = override_config.equal?(NO_OVERRIDE) ? @config : override_config
      return @connection unless cfg&.base_url || cfg&.timeout || cfg&.retry_config

      HTTP::Connection.new(
        cfg.base_url || @connection.base_url,
        @connection.default_headers,
        timeout: cfg.timeout || @connection.timeout,
        retry_config: cfg.retry_config || @connection.retry_config,
      )
    end

    def resolve_config(override_config)
      override_config.equal?(NO_OVERRIDE) ? @config : override_config
    end
  end
end
