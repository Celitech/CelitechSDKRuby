# frozen_string_literal: true

module Celitech
  class Packages
    NO_OVERRIDE = Object.new.freeze
    private_constant :NO_OVERRIDE

    def initialize(connection, config = nil, token_manager: nil)
      @connection = connection
      @config = config
      @token_manager = token_manager
    end

    # List Packages
    def list_packages(
      destination: nil,
      data_limit_in_gb: nil,
      start_date: nil,
      end_date: nil,
      after_cursor: nil,
      limit: nil,
      start_time: nil,
      end_time: nil,
      include_unlimited: nil,
      config: NO_OVERRIDE
    )
      query_params = {
        'destination' => destination,
        'dataLimitInGB' => data_limit_in_gb,
        'startDate' => start_date,
        'endDate' => end_date,
        'afterCursor' => after_cursor,
        'limit' => limit,
        'startTime' => start_time,
        'endTime' => end_time,
        'includeUnlimited' => include_unlimited,
      }.compact
      query_params = query_params.merge(resolve_config(config)&.additional_query_parameters || {})
      headers = config_headers(config).merge(resolve_config(config)&.additional_headers || {})
      conn = resolve_connection(config)
      response = conn.get('/packages', query_params, headers)
      return response if !config.equal?(NO_OVERRIDE) && config&.return_raw
      result = ::Celitech::Models::ListPackagesOkResponse.from_hash(response.body)
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
