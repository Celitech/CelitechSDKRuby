# frozen_string_literal: true

module Celitech
  module ESim
    module Types
      class SuspendEsimRequest < ::Celitech::Internal::Types::Model
        field :iccid, -> { String }, optional: false, nullable: false

        field :idempotency_key, -> { String }, optional: true, nullable: false, api_name: 'Idempotency-Key'
      end
    end
  end
end
