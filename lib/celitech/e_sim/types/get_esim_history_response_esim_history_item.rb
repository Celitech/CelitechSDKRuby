# frozen_string_literal: true

module Celitech
  module ESim
    module Types
      class GetEsimHistoryResponseEsimHistoryItem < ::Celitech::Internal::Types::Model
        field :status, -> { String }, optional: false, nullable: false
        field :status_date, -> { String }, optional: false, nullable: false, api_name: 'statusDate'
        field :date, -> { Float }, optional: true, nullable: false

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
