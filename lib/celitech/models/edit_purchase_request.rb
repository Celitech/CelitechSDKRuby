# frozen_string_literal: true

module Celitech
  module Models
    class EditPurchaseRequest
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          purchase_id: 'purchaseId',
          start_date: 'startDate',
          end_date: 'endDate',
          start_time: 'startTime',
          end_time: 'endTime',
        }.freeze
      end

      def purchase_id
        val = @purchase_id
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def start_date
        val = @start_date
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def end_date
        val = @end_date
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def start_time
        val = @start_time
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def end_time
        val = @end_time
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        purchase_id: ::Celitech::Models::UNSET,
        start_date: ::Celitech::Models::UNSET,
        end_date: ::Celitech::Models::UNSET,
        start_time: ::Celitech::Models::UNSET,
        end_time: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @purchase_id = purchase_id
        @start_date = start_date
        @end_date = end_date
        @start_time = start_time
        @end_time = end_time
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          purchase_id: hash.fetch('purchaseId', ::Celitech::Models::UNSET),
          start_date: hash.fetch('startDate', ::Celitech::Models::UNSET),
          end_date: hash.fetch('endDate', ::Celitech::Models::UNSET),
          start_time: hash.fetch('startTime', ::Celitech::Models::UNSET),
          end_time: hash.fetch('endTime', ::Celitech::Models::UNSET),
          additional_properties: hash.except('purchaseId', 'startDate', 'endDate', 'startTime', 'endTime'),
        )
      end

      def attributes
        {
          purchase_id: @purchase_id,
          start_date: @start_date,
          end_date: @end_date,
          start_time: @start_time,
          end_time: @end_time,
        }
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
