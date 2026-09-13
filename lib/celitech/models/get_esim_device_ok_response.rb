# frozen_string_literal: true

module Celitech
  module Models
    class GetEsimDeviceOkResponse
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          device: 'device',
        }.freeze
      end

      def device
        val = @device
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(device: ::Celitech::Models::UNSET, additional_properties: {})
        @device = device
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          device:
            hash.key?('device') ? ::Celitech::Models::Device.from_hash(hash['device']) : ::Celitech::Models::UNSET,
          additional_properties: hash.except('device'),
        )
      end

      def attributes
        {
          device: @device,
        }
      end

      def validate!
        @device&.validate! if !@device.equal?(::Celitech::Models::UNSET) && @device.respond_to?(:validate!)
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
