# frozen_string_literal: true

module Celitech
  module Internal
    module Types
      module Unknown
        include ::Celitech::Internal::Types::Type

        def coerce(value)
          value
        end
      end
    end
  end
end
