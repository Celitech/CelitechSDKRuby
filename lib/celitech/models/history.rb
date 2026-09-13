# frozen_string_literal: true

module Celitech
  module Models
    class History
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          status: 'status',
          status_date: 'statusDate',
          date: 'date',
        }.freeze
      end

      def status
        val = @status
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def status_date
        val = @status_date
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def date
        val = @date
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        status: ::Celitech::Models::UNSET,
        status_date: ::Celitech::Models::UNSET,
        date: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @status = status
        @status_date = status_date
        @date = date
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          status: hash.fetch('status', ::Celitech::Models::UNSET),
          status_date: hash.fetch('statusDate', ::Celitech::Models::UNSET),
          date: hash.fetch('date', ::Celitech::Models::UNSET),
          additional_properties: hash.except('status', 'statusDate', 'date'),
        )
      end

      def attributes
        {
          status: @status,
          status_date: @status_date,
          date: @date,
        }
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
