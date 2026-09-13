# frozen_string_literal: true

module Celitech
  module Models
    # Marker module for oneOf/anyOf union wrapper classes.
    #
    # Including classes hold one typed variant in +#value+.
    # Serializers check for this module to delegate serialization to the wrapped value.
    module UnionType
    end
  end
end
