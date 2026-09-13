# frozen_string_literal: true

module Celitech
  module Models
    class Device
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          oem: 'oem',
          hardware_name: 'hardwareName',
          hardware_model: 'hardwareModel',
          eid: 'eid',
        }.freeze
      end

      def oem
        val = @oem
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def hardware_name
        val = @hardware_name
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def hardware_model
        val = @hardware_model
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def eid
        val = @eid
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        oem: ::Celitech::Models::UNSET,
        hardware_name: ::Celitech::Models::UNSET,
        hardware_model: ::Celitech::Models::UNSET,
        eid: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @oem = oem
        @hardware_name = hardware_name
        @hardware_model = hardware_model
        @eid = eid
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          oem: hash.fetch('oem', ::Celitech::Models::UNSET),
          hardware_name: hash.fetch('hardwareName', ::Celitech::Models::UNSET),
          hardware_model: hash.fetch('hardwareModel', ::Celitech::Models::UNSET),
          eid: hash.fetch('eid', ::Celitech::Models::UNSET),
          additional_properties: hash.except('oem', 'hardwareName', 'hardwareModel', 'eid'),
        )
      end

      def attributes
        {
          oem: @oem,
          hardware_name: @hardware_name,
          hardware_model: @hardware_model,
          eid: @eid,
        }
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
