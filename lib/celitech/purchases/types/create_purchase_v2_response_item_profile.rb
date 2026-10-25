# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      class CreatePurchaseV2ResponseItemProfile < ::Celitech::Internal::Types::Model
        field :iccid, -> { String }, optional: false, nullable: false
        field :activation_code, -> { String }, optional: false, nullable: false, api_name: 'activationCode'
        field :manual_activation_code, -> { String }, optional: false, nullable: false, api_name: 'manualActivationCode'
        field :ios_activation_link, -> { String }, optional: false, nullable: false, api_name: 'iosActivationLink'
        field :android_activation_link, -> { String }, optional: false, nullable: false, api_name: 'androidActivationLink'

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
