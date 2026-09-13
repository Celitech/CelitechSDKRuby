# frozen_string_literal: true

module Celitech
  module Models
    class ListDestinationsOkResponse
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          destinations: 'destinations',
        }.freeze
      end

      def destinations
        val = @destinations
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(destinations: ::Celitech::Models::UNSET, additional_properties: {})
        @destinations = destinations
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          destinations: hash.fetch('destinations', ::Celitech::Models::UNSET),
          additional_properties: hash.except('destinations'),
        )
      end

      def attributes
        {
          destinations: @destinations,
        }
      end

      def validate!
        @destinations&.each { |item| item.validate! if item.respond_to?(:validate!) } unless @destinations.equal?(::Celitech::Models::UNSET)
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
