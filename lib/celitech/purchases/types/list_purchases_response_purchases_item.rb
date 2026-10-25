# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      class ListPurchasesResponsePurchasesItem < ::Celitech::Internal::Types::Model
        field :id, -> { String }, optional: false, nullable: false
        field :start_date, -> { String }, optional: false, nullable: true, api_name: 'startDate'
        field :end_date, -> { String }, optional: false, nullable: true, api_name: 'endDate'
        field :duration, -> { Float }, optional: true, nullable: true
        field :created_date, -> { String }, optional: false, nullable: false, api_name: 'createdDate'
        field :start_time, -> { Float }, optional: true, nullable: true, api_name: 'startTime'
        field :end_time, -> { Float }, optional: true, nullable: true, api_name: 'endTime'
        field :created_at, -> { Float }, optional: true, nullable: false, api_name: 'createdAt'
        field :package, -> { ::Celitech::Purchases::Types::ListPurchasesResponsePurchasesItemPackage }, optional: false, nullable: false
        field :esim, -> { ::Celitech::Purchases::Types::ListPurchasesResponsePurchasesItemEsim }, optional: false, nullable: false
        field :source, -> { String }, optional: false, nullable: false
        field :purchase_type, -> { String }, optional: false, nullable: false, api_name: 'purchaseType'
        field :reference_id, -> { String }, optional: true, nullable: true, api_name: 'referenceId'

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
