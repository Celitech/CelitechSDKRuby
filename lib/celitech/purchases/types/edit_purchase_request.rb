# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      class EditPurchaseRequest < ::Celitech::Internal::Types::Model
        field :purchase_id, -> { String }, optional: false, nullable: false, api_name: 'purchaseId'
        field :start_date, -> { String }, optional: false, nullable: false, api_name: 'startDate'
        field :end_date, -> { String }, optional: false, nullable: false, api_name: 'endDate'
        field :start_time, -> { Float }, optional: true, nullable: false, api_name: 'startTime'
        field :end_time, -> { Float }, optional: true, nullable: false, api_name: 'endTime'

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
