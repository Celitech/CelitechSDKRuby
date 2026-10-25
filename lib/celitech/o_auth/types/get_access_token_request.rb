# frozen_string_literal: true

module Celitech
  module OAuth
    module Types
      class GetAccessTokenRequest < ::Celitech::Internal::Types::Model
        field :grant_type, -> { ::Celitech::OAuth::Types::GetAccessTokenRequestGrantType }, optional: false, nullable: false
        field :client_id, -> { String }, optional: false, nullable: false
        field :client_secret, -> { String }, optional: false, nullable: false
        field :scope, -> { String }, optional: false, nullable: false

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
