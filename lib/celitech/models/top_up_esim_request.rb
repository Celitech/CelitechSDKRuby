# frozen_string_literal: true

module Celitech
  module Models
    class TopUpEsimRequest
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          iccid: 'iccid',
          data_limit_in_gb: 'dataLimitInGB',
          start_date: 'startDate',
          end_date: 'endDate',
          duration: 'duration',
          email: 'email',
          reference_id: 'referenceId',
          email_brand: 'emailBrand',
          start_time: 'startTime',
          end_time: 'endTime',
        }.freeze
      end

      def iccid
        val = @iccid
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def data_limit_in_gb
        val = @data_limit_in_gb
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

      def email
        val = @email
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def reference_id
        val = @reference_id
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def email_brand
        val = @email_brand
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
        iccid: ::Celitech::Models::UNSET,
        data_limit_in_gb: ::Celitech::Models::UNSET,
        start_date: ::Celitech::Models::UNSET,
        end_date: ::Celitech::Models::UNSET,
        duration: ::Celitech::Models::UNSET,
        email: ::Celitech::Models::UNSET,
        reference_id: ::Celitech::Models::UNSET,
        email_brand: ::Celitech::Models::UNSET,
        start_time: ::Celitech::Models::UNSET,
        end_time: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @iccid = iccid
        @data_limit_in_gb = data_limit_in_gb
        @start_date = start_date
        @end_date = end_date
        @duration = duration
        @email = email
        @reference_id = reference_id
        @email_brand = email_brand
        @start_time = start_time
        @end_time = end_time
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          iccid: hash.fetch('iccid', ::Celitech::Models::UNSET),
          data_limit_in_gb: hash.fetch('dataLimitInGB', ::Celitech::Models::UNSET),
          start_date: hash.fetch('startDate', ::Celitech::Models::UNSET),
          end_date: hash.fetch('endDate', ::Celitech::Models::UNSET),
          duration: hash.fetch('duration', ::Celitech::Models::UNSET),
          email: hash.fetch('email', ::Celitech::Models::UNSET),
          reference_id: hash.fetch('referenceId', ::Celitech::Models::UNSET),
          email_brand: hash.fetch('emailBrand', ::Celitech::Models::UNSET),
          start_time: hash.fetch('startTime', ::Celitech::Models::UNSET),
          end_time: hash.fetch('endTime', ::Celitech::Models::UNSET),
          additional_properties:
            hash.except('iccid', 'dataLimitInGB', 'startDate', 'endDate', 'duration', 'email', 'referenceId', 'emailBrand', 'startTime', 'endTime'),
        )
      end

      def attributes
        {
          iccid: @iccid,
          data_limit_in_gb: @data_limit_in_gb,
          start_date: @start_date,
          end_date: @end_date,
          duration: @duration,
          email: @email,
          reference_id: @reference_id,
          email_brand: @email_brand,
          start_time: @start_time,
          end_time: @end_time,
        }
      end

      def validate!
        Validator.validate_string!(@iccid, 'iccid', min_length: 18, max_length: 22) unless @iccid.equal?(::Celitech::Models::UNSET)
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
