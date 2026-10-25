# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      class CreatePurchaseV2ResponseItem < ::Celitech::Internal::Types::Model
        field :purchase, -> { ::Celitech::Purchases::Types::CreatePurchaseV2ResponseItemPurchase }, optional: false, nullable: false
        field :profile, -> { ::Celitech::Purchases::Types::CreatePurchaseV2ResponseItemProfile }, optional: false, nullable: false

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
