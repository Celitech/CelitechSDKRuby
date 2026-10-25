# frozen_string_literal: true

module Celitech
  module ESim
    module Types
      class GetEsimResponseEsim < ::Celitech::Internal::Types::Model
        field :iccid, -> { String }, optional: false, nullable: false
        field :smdp_address, -> { String }, optional: false, nullable: false, api_name: 'smdpAddress'
        field :activation_code, -> { String }, optional: false, nullable: false, api_name: 'activationCode'
        field :manual_activation_code, -> { String }, optional: false, nullable: false, api_name: 'manualActivationCode'
        field :status, -> { String }, optional: false, nullable: false
        field :connectivity_status, -> { String }, optional: false, nullable: false, api_name: 'connectivityStatus'
        field :is_top_up_allowed, -> { ::Celitech::Internal::Types::Boolean }, optional: false, nullable: false, api_name: 'isTopUpAllowed'

        def validate!
          ::Celitech::Validator.validate_string!(iccid, 'iccid', min_length: 18, max_length: 22)
          ::Celitech::Validator.validate_string!(activation_code, 'activationCode', min_length: 1000, max_length: 8000)
        end

        def self.load(str)
          coerce(::JSON.parse(str, symbolize_names: true))
        end

        def self.dump(value)
          coerced = coerce(value)
          ::JSON.generate(coerced.nil? || !coerced.respond_to?(:to_h) ? coerced : coerced.to_h)
        end
      end
    end
  end
end
