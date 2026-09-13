# frozen_string_literal: true

module Celitech
  module Models
    class Purchases
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          id: 'id',
          start_date: 'startDate',
          end_date: 'endDate',
          duration: 'duration',
          created_date: 'createdDate',
          start_time: 'startTime',
          end_time: 'endTime',
          created_at: 'createdAt',
          package: 'package',
          esim: 'esim',
          source: 'source',
          purchase_type: 'purchaseType',
          reference_id: 'referenceId',
        }.freeze
      end

      def id
        val = @id
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

      def duration
        val = @duration
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

      def created_at
        val = @created_at
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def package
        val = @package
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def esim
        val = @esim
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def source
        val = @source
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def purchase_type
        val = @purchase_type
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def reference_id
        val = @reference_id
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        id: ::Celitech::Models::UNSET,
        start_date: ::Celitech::Models::UNSET,
        end_date: ::Celitech::Models::UNSET,
        duration: ::Celitech::Models::UNSET,
        created_date: ::Celitech::Models::UNSET,
        start_time: ::Celitech::Models::UNSET,
        end_time: ::Celitech::Models::UNSET,
        created_at: ::Celitech::Models::UNSET,
        package: ::Celitech::Models::UNSET,
        esim: ::Celitech::Models::UNSET,
        source: ::Celitech::Models::UNSET,
        purchase_type: ::Celitech::Models::UNSET,
        reference_id: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @id = id
        @start_date = start_date
        @end_date = end_date
        @duration = duration
        @created_date = created_date
        @start_time = start_time
        @end_time = end_time
        @created_at = created_at
        @package = package
        @esim = esim
        @source = source
        @purchase_type = purchase_type
        @reference_id = reference_id
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          id: hash.fetch('id', ::Celitech::Models::UNSET),
          start_date: hash.fetch('startDate', ::Celitech::Models::UNSET),
          end_date: hash.fetch('endDate', ::Celitech::Models::UNSET),
          duration: hash.fetch('duration', ::Celitech::Models::UNSET),
          created_date: hash.fetch('createdDate', ::Celitech::Models::UNSET),
          start_time: hash.fetch('startTime', ::Celitech::Models::UNSET),
          end_time: hash.fetch('endTime', ::Celitech::Models::UNSET),
          created_at: hash.fetch('createdAt', ::Celitech::Models::UNSET),
          package:
            hash.key?('package') ? ::Celitech::Models::Package.from_hash(hash['package']) : ::Celitech::Models::UNSET,
          esim:
            hash.key?('esim') ? ::Celitech::Models::PurchasesEsim.from_hash(hash['esim']) : ::Celitech::Models::UNSET,
          source: hash.fetch('source', ::Celitech::Models::UNSET),
          purchase_type: hash.fetch('purchaseType', ::Celitech::Models::UNSET),
          reference_id: hash.fetch('referenceId', ::Celitech::Models::UNSET),
          additional_properties:
            hash.except('id', 'startDate', 'endDate', 'duration', 'createdDate', 'startTime', 'endTime', 'createdAt', 'package', 'esim', 'source', 'purchaseType', 'referenceId'),
        )
      end

      def attributes
        {
          id: @id,
          start_date: @start_date,
          end_date: @end_date,
          duration: @duration,
          created_date: @created_date,
          start_time: @start_time,
          end_time: @end_time,
          created_at: @created_at,
          package: @package,
          esim: @esim,
          source: @source,
          purchase_type: @purchase_type,
          reference_id: @reference_id,
        }
      end

      def validate!
        @package&.validate! if !@package.equal?(::Celitech::Models::UNSET) && @package.respond_to?(:validate!)
        @esim&.validate! if !@esim.equal?(::Celitech::Models::UNSET) && @esim.respond_to?(:validate!)
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
