# frozen_string_literal: true

module Celitech
  module Models
    class OAuthTokenResponse
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          access_token: 'access_token',
          expires_in: 'expires_in',
        }.freeze
      end

      def access_token
        val = @access_token
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def expires_in
        val = @expires_in
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        access_token: ::Celitech::Models::UNSET,
        expires_in: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @access_token = access_token
        @expires_in = expires_in
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          access_token: hash.fetch('access_token', ::Celitech::Models::UNSET),
          expires_in: hash.fetch('expires_in', ::Celitech::Models::UNSET),
          additional_properties: hash.except('access_token', 'expires_in'),
        )
      end

      def attributes
        {
          access_token: @access_token,
          expires_in: @expires_in,
        }
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
