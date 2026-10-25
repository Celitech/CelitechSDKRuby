# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      module CreatePurchaseV2RequestLanguage
        extend ::Celitech::Internal::Types::Enum

        EN = :en
        ES = :es
        FR = :fr
        DE = :de
        PT_BR = :'pt-br'

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
