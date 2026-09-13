# frozen_string_literal: true

module Celitech
  module Models
    class Destinations
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          name: 'name',
          destination: 'destination',
          destination_iso2: 'destinationISO2',
          supported_countries: 'supportedCountries',
        }.freeze
      end

      def name
        val = @name
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def destination
        val = @destination
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def destination_iso2
        val = @destination_iso2
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def supported_countries
        val = @supported_countries
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        name: ::Celitech::Models::UNSET,
        destination: ::Celitech::Models::UNSET,
        destination_iso2: ::Celitech::Models::UNSET,
        supported_countries: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @name = name
        @destination = destination
        @destination_iso2 = destination_iso2
        @supported_countries = supported_countries
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          name: hash.fetch('name', ::Celitech::Models::UNSET),
          destination: hash.fetch('destination', ::Celitech::Models::UNSET),
          destination_iso2: hash.fetch('destinationISO2', ::Celitech::Models::UNSET),
          supported_countries: hash.fetch('supportedCountries', ::Celitech::Models::UNSET),
          additional_properties: hash.except('name', 'destination', 'destinationISO2', 'supportedCountries'),
        )
      end

      def attributes
        {
          name: @name,
          destination: @destination,
          destination_iso2: @destination_iso2,
          supported_countries: @supported_countries,
        }
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
