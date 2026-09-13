# frozen_string_literal: true

module Celitech
  module Models
    class Package
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          id: 'id',
          data_limit_in_bytes: 'dataLimitInBytes',
          data_limit_in_gb: 'dataLimitInGB',
          destination: 'destination',
          destination_iso2: 'destinationISO2',
          destination_name: 'destinationName',
          price_in_cents: 'priceInCents',
        }.freeze
      end

      def id
        val = @id
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def data_limit_in_bytes
        val = @data_limit_in_bytes
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def data_limit_in_gb
        val = @data_limit_in_gb
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

      def destination_name
        val = @destination_name
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def price_in_cents
        val = @price_in_cents
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        id: ::Celitech::Models::UNSET,
        data_limit_in_bytes: ::Celitech::Models::UNSET,
        data_limit_in_gb: ::Celitech::Models::UNSET,
        destination: ::Celitech::Models::UNSET,
        destination_iso2: ::Celitech::Models::UNSET,
        destination_name: ::Celitech::Models::UNSET,
        price_in_cents: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @id = id
        @data_limit_in_bytes = data_limit_in_bytes
        @data_limit_in_gb = data_limit_in_gb
        @destination = destination
        @destination_iso2 = destination_iso2
        @destination_name = destination_name
        @price_in_cents = price_in_cents
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          id: hash.fetch('id', ::Celitech::Models::UNSET),
          data_limit_in_bytes: hash.fetch('dataLimitInBytes', ::Celitech::Models::UNSET),
          data_limit_in_gb: hash.fetch('dataLimitInGB', ::Celitech::Models::UNSET),
          destination: hash.fetch('destination', ::Celitech::Models::UNSET),
          destination_iso2: hash.fetch('destinationISO2', ::Celitech::Models::UNSET),
          destination_name: hash.fetch('destinationName', ::Celitech::Models::UNSET),
          price_in_cents: hash.fetch('priceInCents', ::Celitech::Models::UNSET),
          additional_properties:
            hash.except('id', 'dataLimitInBytes', 'dataLimitInGB', 'destination', 'destinationISO2', 'destinationName', 'priceInCents'),
        )
      end

      def attributes
        {
          id: @id,
          data_limit_in_bytes: @data_limit_in_bytes,
          data_limit_in_gb: @data_limit_in_gb,
          destination: @destination,
          destination_iso2: @destination_iso2,
          destination_name: @destination_name,
          price_in_cents: @price_in_cents,
        }
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
