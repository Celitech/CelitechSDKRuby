# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      class ListPurchasesResponsePurchasesItemEsim < ::Celitech::Internal::Types::Model
        field :iccid, -> { String }, optional: false, nullable: false

        def validate!
          ::Celitech::Validator.validate_string!(iccid, 'iccid', min_length: 18, max_length: 22)
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
