# frozen_string_literal: true

module Celitech
  class Client
    DEFAULT_BASE_URL = Environment::DEFAULT
    TOKEN_URL = 'https://auth.celitech.net/oauth2/token'

    def initialize(base_url: DEFAULT_BASE_URL, timeout: nil, timeout_ms: nil, client_id: nil, client_secret: nil, token_url: TOKEN_URL)
      unless timeout_ms.nil?
        warn '[DEPRECATION] `timeout_ms` is deprecated; use `timeout` (seconds) instead.', uplevel: 1
        timeout = timeout_ms / 1000.0 if timeout.nil?
      end
      @token_manager = HTTP::OAuthTokenManager.new(
        client_id: client_id,
        client_secret: client_secret,
        token_url: token_url,
      )
      @connection = HTTP::Connection.new(base_url, {}, timeout: timeout)
      @destinations = Destinations.new(@connection, nil, token_manager: @token_manager)
      @packages = Packages.new(@connection, nil, token_manager: @token_manager)
      @purchases = Purchases.new(@connection, nil, token_manager: @token_manager)
      @e_sim = ESim.new(@connection, nil, token_manager: @token_manager)
      @i_frame = IFrame.new(@connection, nil, token_manager: @token_manager)
      @o_auth = OAuth.new(@connection, nil, token_manager: @token_manager)
    end

    def destinations(config: nil)
      return @destinations unless config

      Destinations.new(@connection, config, token_manager: @token_manager)
    end

    def packages(config: nil)
      return @packages unless config

      Packages.new(@connection, config, token_manager: @token_manager)
    end

    def purchases(config: nil)
      return @purchases unless config

      Purchases.new(@connection, config, token_manager: @token_manager)
    end

    def e_sim(config: nil)
      return @e_sim unless config

      ESim.new(@connection, config, token_manager: @token_manager)
    end

    def i_frame(config: nil)
      return @i_frame unless config

      IFrame.new(@connection, config, token_manager: @token_manager)
    end

    def o_auth(config: nil)
      return @o_auth unless config

      OAuth.new(@connection, config, token_manager: @token_manager)
    end

    def client_id=(client_id)
      @token_manager.client_id = client_id
    end

    def client_secret=(client_secret)
      @token_manager.client_secret = client_secret
    end

    def environment=(env)
      self.base_url = Environment.const_get(env.to_s.upcase)
    rescue NameError
      raise ArgumentError, "Unknown environment: #{env.inspect}"
    end

    def base_url=(url)
      @connection.base_url = url
    end
  end
end
