# frozen_string_literal: true

module Celitech
  module Destinations
    module Types
      class ListDestinationsResponseDestinationsItem < ::Celitech::Internal::Types::Model
        field :name, -> { String }, optional: false, nullable: false
        field :destination, -> { String }, optional: false, nullable: false
        field :destination_iso2, -> { String }, optional: false, nullable: false, api_name: 'destinationISO2'
        field :supported_countries, -> { ::Celitech::Internal::Types::Array[String] }, optional: false, nullable: false, api_name: 'supportedCountries'

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
