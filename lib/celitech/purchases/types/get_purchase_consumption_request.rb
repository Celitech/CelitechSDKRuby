# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      class GetPurchaseConsumptionRequest < ::Celitech::Internal::Types::Model
        field :purchase_id, -> { String }, optional: false, nullable: false, api_name: 'purchaseId'
      end
    end
  end
end
