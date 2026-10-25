# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      class CreatePurchaseRequest < ::Celitech::Internal::Types::Model
        field :destination, -> { String }, optional: false, nullable: false
        field :data_limit_in_gb, -> { Float }, optional: false, nullable: false, api_name: 'dataLimitInGB'
        field :start_date, -> { String }, optional: false, nullable: false, api_name: 'startDate'
        field :end_date, -> { String }, optional: false, nullable: false, api_name: 'endDate'
        field :email, -> { String }, optional: true, nullable: false
        field :reference_id, -> { String }, optional: true, nullable: false, api_name: 'referenceId'
        field :network_brand, -> { String }, optional: true, nullable: false, api_name: 'networkBrand'
        field :email_brand, -> { String }, optional: true, nullable: false, api_name: 'emailBrand'
        field :language, -> { ::Celitech::Purchases::Types::CreatePurchaseRequestLanguage }, optional: true, nullable: false
        field :start_time, -> { Float }, optional: true, nullable: false, api_name: 'startTime'
        field :end_time, -> { Float }, optional: true, nullable: false, api_name: 'endTime'

        def validate!
          ::Celitech::Validator.validate_string!(reference_id, 'referenceId', max_length: 255, pattern: /^[a-zA-Z0-9\-_.@+]+$/)
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
