# frozen_string_literal: true

module Celitech
  module Models
    class CreatePurchaseV2Request
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          destination: 'destination',
          data_limit_in_gb: 'dataLimitInGB',
          start_date: 'startDate',
          end_date: 'endDate',
          duration: 'duration',
          quantity: 'quantity',
          email: 'email',
          reference_id: 'referenceId',
          network_brand: 'networkBrand',
          email_brand: 'emailBrand',
          language: 'language',
        }.freeze
      end

      def destination
        val = @destination
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

      def quantity
        val = @quantity
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

      def network_brand
        val = @network_brand
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def email_brand
        val = @email_brand
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def language
        val = @language
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        destination: ::Celitech::Models::UNSET,
        data_limit_in_gb: ::Celitech::Models::UNSET,
        start_date: ::Celitech::Models::UNSET,
        end_date: ::Celitech::Models::UNSET,
        duration: ::Celitech::Models::UNSET,
        quantity: ::Celitech::Models::UNSET,
        email: ::Celitech::Models::UNSET,
        reference_id: ::Celitech::Models::UNSET,
        network_brand: ::Celitech::Models::UNSET,
        email_brand: ::Celitech::Models::UNSET,
        language: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @destination = destination
        @data_limit_in_gb = data_limit_in_gb
        @start_date = start_date
        @end_date = end_date
        @duration = duration
        @quantity = quantity
        @email = email
        @reference_id = reference_id
        @network_brand = network_brand
        @email_brand = email_brand
        @language = language
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          destination: hash.fetch('destination', ::Celitech::Models::UNSET),
          data_limit_in_gb: hash.fetch('dataLimitInGB', ::Celitech::Models::UNSET),
          start_date: hash.fetch('startDate', ::Celitech::Models::UNSET),
          end_date: hash.fetch('endDate', ::Celitech::Models::UNSET),
          duration: hash.fetch('duration', ::Celitech::Models::UNSET),
          quantity: hash.fetch('quantity', ::Celitech::Models::UNSET),
          email: hash.fetch('email', ::Celitech::Models::UNSET),
          reference_id: hash.fetch('referenceId', ::Celitech::Models::UNSET),
          network_brand: hash.fetch('networkBrand', ::Celitech::Models::UNSET),
          email_brand: hash.fetch('emailBrand', ::Celitech::Models::UNSET),
          language: hash.fetch('language', ::Celitech::Models::UNSET),
          additional_properties:
            hash.except('destination', 'dataLimitInGB', 'startDate', 'endDate', 'duration', 'quantity', 'email', 'referenceId', 'networkBrand', 'emailBrand', 'language'),
        )
      end

      def attributes
        {
          destination: @destination,
          data_limit_in_gb: @data_limit_in_gb,
          start_date: @start_date,
          end_date: @end_date,
          duration: @duration,
          quantity: @quantity,
          email: @email,
          reference_id: @reference_id,
          network_brand: @network_brand,
          email_brand: @email_brand,
          language: @language,
        }
      end

      def validate!
        Validator.validate_number!(@quantity, 'quantity', min: 1, max: 5) unless @quantity.equal?(::Celitech::Models::UNSET)
        @language&.validate! if !@language.equal?(::Celitech::Models::UNSET) && @language.respond_to?(:validate!)
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
