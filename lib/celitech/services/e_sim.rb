# frozen_string_literal: true

module Celitech
  class ESim
    NO_OVERRIDE = Object.new.freeze
    private_constant :NO_OVERRIDE

    def initialize(connection, config = nil, token_manager: nil)
      @connection = connection
      @config = config
      @token_manager = token_manager
    end

    # Get eSIM
    def get_esim(iccid:, config: NO_OVERRIDE)
      query_params = {
        'iccid' => iccid,
      }.compact
      query_params = query_params.merge(resolve_config(config)&.additional_query_parameters || {})
      headers = config_headers(config).merge(resolve_config(config)&.additional_headers || {})
      Validator.validate_string!(iccid, 'iccid', min_length: 18, max_length: 22)
      conn = resolve_connection(config)
      response = conn.get('/esim', query_params, headers)
      return response if !config.equal?(NO_OVERRIDE) && config&.return_raw
      result = ::Celitech::Models::GetEsimOkResponse.from_hash(response.body)
      result&.validate! if resolve_config(config)&.enable_response_validation
      result
    rescue APIError => e
      case e.status
      when 400, 401, 409, 422, 503
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::ErrorResponse.from_hash(e.body) : nil
        raise ::Celitech::ErrorResponseError.new(e.status, parsed, e.body, e.headers)
      end
      raise
    end

    # Get eSIM Device
    def get_esim_device(iccid:, config: NO_OVERRIDE)
      headers = config_headers(config).merge(resolve_config(config)&.additional_headers || {})
      Validator.validate_string!(iccid, 'iccid', min_length: 18, max_length: 22)
      conn = resolve_connection(config)
      response = conn.get("/esim/#{Serializers::Params.simple(iccid, explode: false)}/device", {}, headers)
      return response if !config.equal?(NO_OVERRIDE) && config&.return_raw
      result = ::Celitech::Models::GetEsimDeviceOkResponse.from_hash(response.body)
      result&.validate! if resolve_config(config)&.enable_response_validation
      result
    rescue APIError => e
      case e.status
      when 400, 401, 409, 422, 503
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::ErrorResponse.from_hash(e.body) : nil
        raise ::Celitech::ErrorResponseError.new(e.status, parsed, e.body, e.headers)
      end
      raise
    end

    # Get eSIM History
    def get_esim_history(iccid:, config: NO_OVERRIDE)
      headers = config_headers(config).merge(resolve_config(config)&.additional_headers || {})
      Validator.validate_string!(iccid, 'iccid', min_length: 18, max_length: 22)
      conn = resolve_connection(config)
      response = conn.get("/esim/#{Serializers::Params.simple(iccid, explode: false)}/history", {}, headers)
      return response if !config.equal?(NO_OVERRIDE) && config&.return_raw
      result = ::Celitech::Models::GetEsimHistoryOkResponse.from_hash(response.body)
      result&.validate! if resolve_config(config)&.enable_response_validation
      result
    rescue APIError => e
      case e.status
      when 400, 401, 409, 422, 503
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::ErrorResponse.from_hash(e.body) : nil
        raise ::Celitech::ErrorResponseError.new(e.status, parsed, e.body, e.headers)
      end
      raise
    end

    # Suspend eSIM
    def suspend_esim(iccid:, idempotency_key: nil, config: NO_OVERRIDE)
      headers = config_headers(config).merge(
        {
          'Idempotency-Key' => idempotency_key,
        }.compact,
      ).merge(resolve_config(config)&.additional_headers || {})
      Validator.validate_string!(iccid, 'iccid', min_length: 18, max_length: 22)
      Validator.validate_string!(idempotency_key, 'Idempotency-Key', min_length: 1, max_length: 255)
      conn = resolve_connection(config)
      response = conn.post("/esim/#{Serializers::Params.simple(iccid, explode: false)}/suspend", nil, headers: headers)
      return response if !config.equal?(NO_OVERRIDE) && config&.return_raw
      result = ::Celitech::Models::SuspendEsimOkResponse.from_hash(response.body)
      result&.validate! if resolve_config(config)&.enable_response_validation
      result
    rescue APIError => e
      case e.status
      when 400, 401, 409, 422, 503
        parsed = e.body.is_a?(Hash) ? ::Celitech::Models::ErrorResponse.from_hash(e.body) : nil
        raise ::Celitech::ErrorResponseError.new(e.status, parsed, e.body, e.headers)
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
