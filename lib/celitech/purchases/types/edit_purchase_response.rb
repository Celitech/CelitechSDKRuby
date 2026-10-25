# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      class EditPurchaseResponse < ::Celitech::Internal::Types::Model
        field :purchase_id, -> { String }, optional: false, nullable: false, api_name: 'purchaseId'
        field :new_start_date, -> { String }, optional: false, nullable: true, api_name: 'newStartDate'
        field :new_end_date, -> { String }, optional: false, nullable: true, api_name: 'newEndDate'
        field :new_start_time, -> { Float }, optional: true, nullable: true, api_name: 'newStartTime'
        field :new_end_time, -> { Float }, optional: true, nullable: true, api_name: 'newEndTime'

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
