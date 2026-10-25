# frozen_string_literal: true

module Celitech
  module OAuth
    module Types
      module GetAccessTokenRequestGrantType
        extend ::Celitech::Internal::Types::Enum

        CLIENT_CREDENTIALS = :client_credentials

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
