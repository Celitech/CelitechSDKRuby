# frozen_string_literal: true

module Celitech
  module Models
    class Unauthorized
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          message: 'message',
        }.freeze
      end

      def message
        val = @message
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(message: ::Celitech::Models::UNSET, additional_properties: {})
        @message = message
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          message: hash.fetch('message', ::Celitech::Models::UNSET),
          additional_properties: hash.except('message'),
        )
      end

      def attributes
        {
          message: @message,
        }
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
