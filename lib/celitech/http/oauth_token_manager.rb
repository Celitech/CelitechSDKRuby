# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'

module Celitech
  module HTTP
    class OAuthError < StandardError; end

    # Manages OAuth 2.0 client credentials tokens: fetches, caches, and refreshes them.
    # Token refresh is triggered when the token is absent or within REFRESH_BUFFER_SECS
    # of expiry. A Mutex ensures thread-safe access to the cached token.
    # Note: token refresh blocks all threads calling `headers` until the HTTP request
    # completes. This is intentional — only one fetch occurs and others reuse the result.
    class OAuthTokenManager
      REFRESH_BUFFER_SECS = 5

      def initialize(client_id:, client_secret:, token_url:)
        @client_id     = client_id
        @client_secret = client_secret
        @token_url     = token_url
        @access_token  = nil
        @expires_at    = nil
        @mutex         = Mutex.new
      end

      attr_writer :client_id, :client_secret

      def headers
        { 'Authorization' => "Bearer #{token}" }
      end

      # Force the next call to re-fetch a fresh token.
      def invalidate
        @mutex.synchronize { @access_token = nil }
      end

      private

      def token
        @mutex.synchronize do
          fetch_token if token_expired?
          @access_token
        end
      end

      def token_expired?
        @access_token.nil? || (@expires_at && Time.now + REFRESH_BUFFER_SECS >= @expires_at)
      end

      def fetch_token
        uri = URI.parse(@token_url)
        req = Net::HTTP::Post.new(uri.request_uri)
        req.set_form_data(
          grant_type: 'client_credentials',
          client_id: @client_id,
          client_secret: @client_secret,
        )

        # Net::HTTP.start with a block opens and closes the connection automatically.
        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request(req)
        end
        raise OAuthError, "token request failed (HTTP #{response.code}): #{response.body}" unless response.is_a?(Net::HTTPSuccess)

        body = JSON.parse(response.body)
        raise OAuthError, 'access_token missing from token response' unless body.key?('access_token')

        @access_token = body['access_token']
        expires_in    = body['expires_in']
        @expires_at   = expires_in ? Time.now + expires_in.to_i : nil
      end
    end
  end
end
