# frozen_string_literal: true

module Celitech
  module Destinations
    module Types
      class ListDestinationsResponse < ::Celitech::Internal::Types::Model
        field :destinations, -> { ::Celitech::Internal::Types::Array[::Celitech::Destinations::Types::ListDestinationsResponseDestinationsItem] }, optional: false, nullable: false

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
