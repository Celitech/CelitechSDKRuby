# frozen_string_literal: true

require 'securerandom'

module Celitech
  module Internal
    # Generates the idempotency key a request carries when the caller supplies none.
    class IdempotencyKey
      # @return [String]
      def self.generate
        SecureRandom.uuid
      end
    end
  end
end
