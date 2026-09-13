# frozen_string_literal: true

module Celitech
  module Models
    class TokenOkResponse
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          token: 'token',
        }.freeze
      end

      def token
        val = @token
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(token: ::Celitech::Models::UNSET, additional_properties: {})
        @token = token
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          token: hash.fetch('token', ::Celitech::Models::UNSET),
          additional_properties: hash.except('token'),
        )
      end

      def attributes
        {
          token: @token,
        }
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
