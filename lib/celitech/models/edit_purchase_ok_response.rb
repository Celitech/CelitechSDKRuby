# frozen_string_literal: true

module Celitech
  module Models
    class EditPurchaseOkResponse
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          purchase_id: 'purchaseId',
          new_start_date: 'newStartDate',
          new_end_date: 'newEndDate',
          new_start_time: 'newStartTime',
          new_end_time: 'newEndTime',
        }.freeze
      end

      def purchase_id
        val = @purchase_id
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def new_start_date
        val = @new_start_date
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def new_end_date
        val = @new_end_date
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def new_start_time
        val = @new_start_time
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def new_end_time
        val = @new_end_time
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        purchase_id: ::Celitech::Models::UNSET,
        new_start_date: ::Celitech::Models::UNSET,
        new_end_date: ::Celitech::Models::UNSET,
        new_start_time: ::Celitech::Models::UNSET,
        new_end_time: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @purchase_id = purchase_id
        @new_start_date = new_start_date
        @new_end_date = new_end_date
        @new_start_time = new_start_time
        @new_end_time = new_end_time
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          purchase_id: hash.fetch('purchaseId', ::Celitech::Models::UNSET),
          new_start_date: hash.fetch('newStartDate', ::Celitech::Models::UNSET),
          new_end_date: hash.fetch('newEndDate', ::Celitech::Models::UNSET),
          new_start_time: hash.fetch('newStartTime', ::Celitech::Models::UNSET),
          new_end_time: hash.fetch('newEndTime', ::Celitech::Models::UNSET),
          additional_properties: hash.except('purchaseId', 'newStartDate', 'newEndDate', 'newStartTime', 'newEndTime'),
        )
      end

      def attributes
        {
          purchase_id: @purchase_id,
          new_start_date: @new_start_date,
          new_end_date: @new_end_date,
          new_start_time: @new_start_time,
          new_end_time: @new_end_time,
        }
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
