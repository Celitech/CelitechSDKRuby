# frozen_string_literal: true

module Celitech
  module Models
    class GetPurchaseConsumptionOkResponse
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          data_usage_remaining_in_bytes: 'dataUsageRemainingInBytes',
          data_usage_remaining_in_gb: 'dataUsageRemainingInGB',
          status: 'status',
        }.freeze
      end

      def data_usage_remaining_in_bytes
        val = @data_usage_remaining_in_bytes
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def data_usage_remaining_in_gb
        val = @data_usage_remaining_in_gb
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def status
        val = @status
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        data_usage_remaining_in_bytes: ::Celitech::Models::UNSET,
        data_usage_remaining_in_gb: ::Celitech::Models::UNSET,
        status: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @data_usage_remaining_in_bytes = data_usage_remaining_in_bytes
        @data_usage_remaining_in_gb = data_usage_remaining_in_gb
        @status = status
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          data_usage_remaining_in_bytes: hash.fetch('dataUsageRemainingInBytes', ::Celitech::Models::UNSET),
          data_usage_remaining_in_gb: hash.fetch('dataUsageRemainingInGB', ::Celitech::Models::UNSET),
          status: hash.fetch('status', ::Celitech::Models::UNSET),
          additional_properties: hash.except('dataUsageRemainingInBytes', 'dataUsageRemainingInGB', 'status'),
        )
      end

      def attributes
        {
          data_usage_remaining_in_bytes: @data_usage_remaining_in_bytes,
          data_usage_remaining_in_gb: @data_usage_remaining_in_gb,
          status: @status,
        }
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
