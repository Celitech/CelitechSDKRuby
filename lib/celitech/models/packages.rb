# frozen_string_literal: true

module Celitech
  module Models
    class Packages
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          id: 'id',
          destination: 'destination',
          destination_iso2: 'destinationISO2',
          data_limit_in_bytes: 'dataLimitInBytes',
          data_limit_in_gb: 'dataLimitInGB',
          min_days: 'minDays',
          max_days: 'maxDays',
          price_in_cents: 'priceInCents',
        }.freeze
      end

      def id
        val = @id
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

      def data_limit_in_bytes
        val = @data_limit_in_bytes
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def data_limit_in_gb
        val = @data_limit_in_gb
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def min_days
        val = @min_days
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def max_days
        val = @max_days
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def price_in_cents
        val = @price_in_cents
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        id: ::Celitech::Models::UNSET,
        destination: ::Celitech::Models::UNSET,
        destination_iso2: ::Celitech::Models::UNSET,
        data_limit_in_bytes: ::Celitech::Models::UNSET,
        data_limit_in_gb: ::Celitech::Models::UNSET,
        min_days: ::Celitech::Models::UNSET,
        max_days: ::Celitech::Models::UNSET,
        price_in_cents: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @id = id
        @destination = destination
        @destination_iso2 = destination_iso2
        @data_limit_in_bytes = data_limit_in_bytes
        @data_limit_in_gb = data_limit_in_gb
        @min_days = min_days
        @max_days = max_days
        @price_in_cents = price_in_cents
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          id: hash.fetch('id', ::Celitech::Models::UNSET),
          destination: hash.fetch('destination', ::Celitech::Models::UNSET),
          destination_iso2: hash.fetch('destinationISO2', ::Celitech::Models::UNSET),
          data_limit_in_bytes: hash.fetch('dataLimitInBytes', ::Celitech::Models::UNSET),
          data_limit_in_gb: hash.fetch('dataLimitInGB', ::Celitech::Models::UNSET),
          min_days: hash.fetch('minDays', ::Celitech::Models::UNSET),
          max_days: hash.fetch('maxDays', ::Celitech::Models::UNSET),
          price_in_cents: hash.fetch('priceInCents', ::Celitech::Models::UNSET),
          additional_properties:
            hash.except('id', 'destination', 'destinationISO2', 'dataLimitInBytes', 'dataLimitInGB', 'minDays', 'maxDays', 'priceInCents'),
        )
      end

      def attributes
        {
          id: @id,
          destination: @destination,
          destination_iso2: @destination_iso2,
          data_limit_in_bytes: @data_limit_in_bytes,
          data_limit_in_gb: @data_limit_in_gb,
          min_days: @min_days,
          max_days: @max_days,
          price_in_cents: @price_in_cents,
        }
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
