# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      class CreatePurchaseV2ResponseItemPurchase < ::Celitech::Internal::Types::Model
        field :id, -> { String }, optional: false, nullable: false
        field :package_id, -> { String }, optional: false, nullable: false, api_name: 'packageId'
        field :created_date, -> { String }, optional: false, nullable: false, api_name: 'createdDate'

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
