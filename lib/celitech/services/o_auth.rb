# frozen_string_literal: true

module Celitech
  class OAuth
    NO_OVERRIDE = Object.new.freeze
    private_constant :NO_OVERRIDE

    def initialize(connection, config = nil, token_manager: nil)
      @connection = connection
      @config = config
      @token_manager = token_manager
    end

    def get_access_token(body:, config: NO_OVERRIDE)
      headers = config_headers(config).merge(resolve_config(config)&.additional_headers || {})
      body.validate! if body.respond_to?(:validate!)
      conn = resolve_connection(config)
      response = conn.post('/oauth2/token', body, content_type: 'application/x-www-form-urlencoded', headers: headers)
      return response if !config.equal?(NO_OVERRIDE) && config&.return_raw
      result = ::Celitech::Models::OAuthTokenResponse.from_hash(response.body)
      result&.validate! if resolve_config(config)&.enable_response_validation
      result
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
