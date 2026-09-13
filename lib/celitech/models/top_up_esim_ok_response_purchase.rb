# frozen_string_literal: true

module Celitech
  module Models
    class TopUpEsimOkResponsePurchase
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          id: 'id',
          package_id: 'packageId',
          start_date: 'startDate',
          end_date: 'endDate',
          created_date: 'createdDate',
          start_time: 'startTime',
          end_time: 'endTime',
        }.freeze
      end

      def id
        val = @id
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def package_id
        val = @package_id
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

      def created_date
        val = @created_date
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
        id: ::Celitech::Models::UNSET,
        package_id: ::Celitech::Models::UNSET,
        start_date: ::Celitech::Models::UNSET,
        end_date: ::Celitech::Models::UNSET,
        created_date: ::Celitech::Models::UNSET,
        start_time: ::Celitech::Models::UNSET,
        end_time: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @id = id
        @package_id = package_id
        @start_date = start_date
        @end_date = end_date
        @created_date = created_date
        @start_time = start_time
        @end_time = end_time
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          id: hash.fetch('id', ::Celitech::Models::UNSET),
          package_id: hash.fetch('packageId', ::Celitech::Models::UNSET),
          start_date: hash.fetch('startDate', ::Celitech::Models::UNSET),
          end_date: hash.fetch('endDate', ::Celitech::Models::UNSET),
          created_date: hash.fetch('createdDate', ::Celitech::Models::UNSET),
          start_time: hash.fetch('startTime', ::Celitech::Models::UNSET),
          end_time: hash.fetch('endTime', ::Celitech::Models::UNSET),
          additional_properties:
            hash.except('id', 'packageId', 'startDate', 'endDate', 'createdDate', 'startTime', 'endTime'),
        )
      end

      def attributes
        {
          id: @id,
          package_id: @package_id,
          start_date: @start_date,
          end_date: @end_date,
          created_date: @created_date,
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
