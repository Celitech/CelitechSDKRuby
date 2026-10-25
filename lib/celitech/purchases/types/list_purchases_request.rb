# frozen_string_literal: true

module Celitech
  module Purchases
    module Types
      class ListPurchasesRequest < ::Celitech::Internal::Types::Model
        field :purchase_id, -> { String }, optional: true, nullable: false, api_name: 'purchaseId'

        field :iccid, -> { String }, optional: true, nullable: false

        field :after_date, -> { String }, optional: true, nullable: false, api_name: 'afterDate'

        field :before_date, -> { String }, optional: true, nullable: false, api_name: 'beforeDate'

        field :email, -> { String }, optional: true, nullable: false

        field :reference_id, -> { String }, optional: true, nullable: false, api_name: 'referenceId'

        field :after_cursor, -> { String }, optional: true, nullable: false, api_name: 'afterCursor'

        field :limit, -> { Float }, optional: true, nullable: false

        field :after, -> { Float }, optional: true, nullable: false

        field :before, -> { Float }, optional: true, nullable: false
      end
    end
  end
end
