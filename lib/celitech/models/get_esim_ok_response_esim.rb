# frozen_string_literal: true

module Celitech
  module Models
    class GetEsimOkResponseEsim
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          iccid: 'iccid',
          smdp_address: 'smdpAddress',
          activation_code: 'activationCode',
          manual_activation_code: 'manualActivationCode',
          status: 'status',
          connectivity_status: 'connectivityStatus',
          is_top_up_allowed: 'isTopUpAllowed',
        }.freeze
      end

      def iccid
        val = @iccid
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def smdp_address
        val = @smdp_address
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

      def status
        val = @status
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def connectivity_status
        val = @connectivity_status
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def is_top_up_allowed
        val = @is_top_up_allowed
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        iccid: ::Celitech::Models::UNSET,
        smdp_address: ::Celitech::Models::UNSET,
        activation_code: ::Celitech::Models::UNSET,
        manual_activation_code: ::Celitech::Models::UNSET,
        status: ::Celitech::Models::UNSET,
        connectivity_status: ::Celitech::Models::UNSET,
        is_top_up_allowed: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @iccid = iccid
        @smdp_address = smdp_address
        @activation_code = activation_code
        @manual_activation_code = manual_activation_code
        @status = status
        @connectivity_status = connectivity_status
        @is_top_up_allowed = is_top_up_allowed
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          iccid: hash.fetch('iccid', ::Celitech::Models::UNSET),
          smdp_address: hash.fetch('smdpAddress', ::Celitech::Models::UNSET),
          activation_code: hash.fetch('activationCode', ::Celitech::Models::UNSET),
          manual_activation_code: hash.fetch('manualActivationCode', ::Celitech::Models::UNSET),
          status: hash.fetch('status', ::Celitech::Models::UNSET),
          connectivity_status: hash.fetch('connectivityStatus', ::Celitech::Models::UNSET),
          is_top_up_allowed: hash.fetch('isTopUpAllowed', ::Celitech::Models::UNSET),
          additional_properties:
            hash.except('iccid', 'smdpAddress', 'activationCode', 'manualActivationCode', 'status', 'connectivityStatus', 'isTopUpAllowed'),
        )
      end

      def attributes
        {
          iccid: @iccid,
          smdp_address: @smdp_address,
          activation_code: @activation_code,
          manual_activation_code: @manual_activation_code,
          status: @status,
          connectivity_status: @connectivity_status,
          is_top_up_allowed: @is_top_up_allowed,
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
