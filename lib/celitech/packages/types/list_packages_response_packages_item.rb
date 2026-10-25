# frozen_string_literal: true

module Celitech
  module Packages
    module Types
      class ListPackagesResponsePackagesItem < ::Celitech::Internal::Types::Model
        field :id, -> { String }, optional: false, nullable: false
        field :destination, -> { String }, optional: false, nullable: false
        field :destination_iso2, -> { String }, optional: false, nullable: false, api_name: 'destinationISO2'
        field :data_limit_in_bytes, -> { Float }, optional: false, nullable: false, api_name: 'dataLimitInBytes'
        field :data_limit_in_gb, -> { Float }, optional: false, nullable: false, api_name: 'dataLimitInGB'
        field :min_days, -> { Float }, optional: false, nullable: false, api_name: 'minDays'
        field :max_days, -> { Float }, optional: false, nullable: false, api_name: 'maxDays'
        field :price_in_cents, -> { Float }, optional: false, nullable: false, api_name: 'priceInCents'

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
