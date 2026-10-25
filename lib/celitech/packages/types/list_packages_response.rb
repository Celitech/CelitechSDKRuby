# frozen_string_literal: true

module Celitech
  module Packages
    module Types
      class ListPackagesResponse < ::Celitech::Internal::Types::Model
        field :packages, -> { ::Celitech::Internal::Types::Array[::Celitech::Packages::Types::ListPackagesResponsePackagesItem] }, optional: false, nullable: false
        field :after_cursor, -> { String }, optional: false, nullable: true, api_name: 'afterCursor'

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
