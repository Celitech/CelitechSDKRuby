# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      class GetPurchaseConsumptionResponse < ::Celitech::Internal::Types::Model
        field :data_usage_remaining_in_bytes, -> { Float }, optional: false, nullable: false, api_name: 'dataUsageRemainingInBytes'
        field :data_usage_remaining_in_gb, -> { Float }, optional: false, nullable: false, api_name: 'dataUsageRemainingInGB'
        field :status, -> { String }, optional: false, nullable: false

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
