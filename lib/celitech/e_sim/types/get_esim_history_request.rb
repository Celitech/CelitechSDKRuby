# frozen_string_literal: true

module Celitech
  module ESim
    module Types
      class GetEsimHistoryRequest < ::Celitech::Internal::Types::Model
        field :iccid, -> { String }, optional: false, nullable: false
      end
    end
  end
end
