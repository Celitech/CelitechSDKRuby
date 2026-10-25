# frozen_string_literal: true

module Celitech
  class Client
    DEFAULT_BASE_URL = Environment::DEFAULT
    TOKEN_URL = 'https://auth.celitech.net/oauth2/token'

    def initialize(client_id:, client_secret:, base_url: nil, max_retries: 2, timeout: 60, token_url: TOKEN_URL)
      @token_manager = HTTP::OAuthTokenManager.new(
        client_id: client_id,
        client_secret: client_secret,
        token_url: token_url,
        base_url: base_url || DEFAULT_BASE_URL,
      )
      headers = { 'X-Fern-Language' => 'Ruby' }
      @raw_client = Internal::Http::RawClient.new(
        base_url: base_url || DEFAULT_BASE_URL,
        headers: headers,
        max_retries: max_retries,
        timeout: timeout,
        token_provider: -> { @token_manager.headers['Authorization'] },
      )
    end

    def destinations
      @destinations ||= Destinations::Client.new(client: @raw_client)
    end

    def packages
      @packages ||= Packages::Client.new(client: @raw_client)
    end

    def purchases
      @purchases ||= Purchases::Client.new(client: @raw_client)
    end

    def e_sim
      @e_sim ||= ESim::Client.new(client: @raw_client)
    end

    def i_frame
      @i_frame ||= IFrame::Client.new(client: @raw_client)
    end

    def o_auth
      @o_auth ||= OAuth::Client.new(client: @raw_client)
    end

    def client_id=(client_id)
      @token_manager.client_id = client_id
    end

    def client_secret=(client_secret)
      @token_manager.client_secret = client_secret
    end
  end
end
