# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      class CreatePurchaseV2Request < ::Celitech::Internal::Types::Model
        field :destination, -> { String }, optional: false, nullable: false
        field :data_limit_in_gb, -> { Float }, optional: false, nullable: false, api_name: 'dataLimitInGB'
        field :start_date, -> { String }, optional: true, nullable: false, api_name: 'startDate'
        field :end_date, -> { String }, optional: true, nullable: false, api_name: 'endDate'
        field :duration, -> { Float }, optional: true, nullable: false
        field :quantity, -> { Float }, optional: false, nullable: false
        field :email, -> { String }, optional: true, nullable: false
        field :reference_id, -> { String }, optional: true, nullable: false, api_name: 'referenceId'
        field :network_brand, -> { String }, optional: true, nullable: false, api_name: 'networkBrand'
        field :email_brand, -> { String }, optional: true, nullable: false, api_name: 'emailBrand'
        field :language, -> { ::Celitech::Purchases::Types::CreatePurchaseV2RequestLanguage }, optional: true, nullable: false

        def validate!
          Validator.validate_number!(quantity, 'quantity', min: 1, max: 5)
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
