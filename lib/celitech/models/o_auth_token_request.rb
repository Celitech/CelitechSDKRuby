# frozen_string_literal: true

module Celitech
  module Models
    class OAuthTokenRequest
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          grant_type: 'grant_type',
          client_id: 'client_id',
          client_secret: 'client_secret',
          scope: 'scope',
        }.freeze
      end

      def grant_type
        val = @grant_type
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def client_id
        val = @client_id
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def client_secret
        val = @client_secret
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def scope
        val = @scope
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        grant_type: ::Celitech::Models::UNSET,
        client_id: ::Celitech::Models::UNSET,
        client_secret: ::Celitech::Models::UNSET,
        scope: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @grant_type = grant_type
        @client_id = client_id
        @client_secret = client_secret
        @scope = scope
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          grant_type: hash.fetch('grant_type', ::Celitech::Models::UNSET),
          client_id: hash.fetch('client_id', ::Celitech::Models::UNSET),
          client_secret: hash.fetch('client_secret', ::Celitech::Models::UNSET),
          scope: hash.fetch('scope', ::Celitech::Models::UNSET),
          additional_properties: hash.except('grant_type', 'client_id', 'client_secret', 'scope'),
        )
      end

      def attributes
        {
          grant_type: @grant_type,
          client_id: @client_id,
          client_secret: @client_secret,
          scope: @scope,
        }
      end

      def validate!
        @grant_type&.validate! if !@grant_type.equal?(::Celitech::Models::UNSET) && @grant_type.respond_to?(:validate!)
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
