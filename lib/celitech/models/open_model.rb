# frozen_string_literal: true

module Celitech
  module Models
    # Marker module for open object models (additionalProperties: true).
    #
    # Including classes must implement:
    #   - #open_model_extras → Hash of extra key/value pairs captured from deserialization
    #
    # In return, this module overrides +#to_h+ to merge the extras into the
    # symbol-keyed hash produced by +Serializable#to_h+, so round-trips through
    # JSON preserve unknown fields without requiring schema changes.
    #
    # +#to_h+ is a symbol-keyed Ruby view: declared fields keep their attribute names and win
    # on collision. +Serializers::Json.serialize+ is the wire-faithful path (keeps raw wire
    # keys) and is what guarantees the unknown-field round-trip.
    module OpenModel
      def open_model_extras
        raise NotImplementedError, "#{self.class} must implement #open_model_extras"
      end

      def to_h
        extras = open_model_extras
        return super if extras.nil? || extras.empty?

        extras.transform_keys(&:to_sym).merge(super)
      end
    end
  end
end
