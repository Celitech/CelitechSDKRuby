# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      class TopUpEsimResponsePurchase < ::Celitech::Internal::Types::Model
        field :id, -> { String }, optional: false, nullable: false
        field :package_id, -> { String }, optional: false, nullable: false, api_name: 'packageId'
        field :start_date, -> { String }, optional: false, nullable: true, api_name: 'startDate'
        field :end_date, -> { String }, optional: false, nullable: true, api_name: 'endDate'
        field :created_date, -> { String }, optional: false, nullable: false, api_name: 'createdDate'
        field :start_time, -> { Float }, optional: true, nullable: true, api_name: 'startTime'
        field :end_time, -> { Float }, optional: true, nullable: true, api_name: 'endTime'

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
