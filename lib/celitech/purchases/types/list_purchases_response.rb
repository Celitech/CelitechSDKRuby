# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      class ListPurchasesResponse < ::Celitech::Internal::Types::Model
        field :purchases, -> { ::Celitech::Internal::Types::Array[::Celitech::Purchases::Types::ListPurchasesResponsePurchasesItem] }, optional: false, nullable: false
        field :after_cursor, -> { String }, optional: false, nullable: true, api_name: 'afterCursor'

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
