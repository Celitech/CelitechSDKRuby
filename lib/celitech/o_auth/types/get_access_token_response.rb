# frozen_string_literal: true

module Celitech
  module OAuth
    module Types
      class GetAccessTokenResponse < ::Celitech::Internal::Types::Model
        field :access_token, -> { String }, optional: true, nullable: false
        field :expires_in, -> { Integer }, optional: true, nullable: true

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
