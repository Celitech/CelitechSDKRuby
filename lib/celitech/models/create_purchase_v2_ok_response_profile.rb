# frozen_string_literal: true

module Celitech
  module Models
    class CreatePurchaseV2OkResponseProfile
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          iccid: 'iccid',
          activation_code: 'activationCode',
          manual_activation_code: 'manualActivationCode',
          ios_activation_link: 'iosActivationLink',
          android_activation_link: 'androidActivationLink',
        }.freeze
      end

      def iccid
        val = @iccid
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def activation_code
        val = @activation_code
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def manual_activation_code
        val = @manual_activation_code
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def ios_activation_link
        val = @ios_activation_link
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def android_activation_link
        val = @android_activation_link
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        iccid: ::Celitech::Models::UNSET,
        activation_code: ::Celitech::Models::UNSET,
        manual_activation_code: ::Celitech::Models::UNSET,
        ios_activation_link: ::Celitech::Models::UNSET,
        android_activation_link: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @iccid = iccid
        @activation_code = activation_code
        @manual_activation_code = manual_activation_code
        @ios_activation_link = ios_activation_link
        @android_activation_link = android_activation_link
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          iccid: hash.fetch('iccid', ::Celitech::Models::UNSET),
          activation_code: hash.fetch('activationCode', ::Celitech::Models::UNSET),
          manual_activation_code: hash.fetch('manualActivationCode', ::Celitech::Models::UNSET),
          ios_activation_link: hash.fetch('iosActivationLink', ::Celitech::Models::UNSET),
          android_activation_link: hash.fetch('androidActivationLink', ::Celitech::Models::UNSET),
          additional_properties:
            hash.except('iccid', 'activationCode', 'manualActivationCode', 'iosActivationLink', 'androidActivationLink'),
        )
      end

      def attributes
        {
          iccid: @iccid,
          activation_code: @activation_code,
          manual_activation_code: @manual_activation_code,
          ios_activation_link: @ios_activation_link,
          android_activation_link: @android_activation_link,
        }
      end

      def validate!
        Validator.validate_string!(@iccid, 'iccid', min_length: 18, max_length: 22) unless @iccid.equal?(::Celitech::Models::UNSET)
        Validator.validate_string!(@activation_code, 'activationCode', min_length: 1000, max_length: 8000) unless @activation_code.equal?(::Celitech::Models::UNSET)
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
