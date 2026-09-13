# frozen_string_literal: true

module Celitech
  module Models
    # Sentinel value for model fields that were never explicitly set.
    # Distinguishes "field not provided" from "field explicitly set to nil",
    # which matters for PATCH requests where nil means "clear this field".
    UNSET = Object.new.tap do |o|
      o.define_singleton_method(:inspect) { 'UNSET' }
      o.define_singleton_method(:to_s) { 'UNSET' }
    end.freeze

    # Marker module for generated model classes.
    #
    # Including classes must implement:
    #   - .wire_keys → { attr_sym: 'wire_name', ... }.freeze
    #   - .from_hash(hash) → model instance or nil
    #   - #attributes → { attr_sym: raw_value, ... }
    #
    # In return, this module provides:
    #   - #to_h → { attr_sym: value, ... } with nested models recursively converted,
    #             omitting fields set to UNSET but preserving explicit nil
    module Serializable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def wire_keys
          raise NotImplementedError, "#{name} must implement .wire_keys"
        end

        def from_hash(_hash)
          raise NotImplementedError, "#{name} must implement .from_hash"
        end
      end

      def to_h
        self.class.wire_keys.each_with_object({}) do |(attr, _key), hash|
          val = attributes[attr]
          next if val.equal?(UNSET)

          hash[attr] = coerce_to_h(val)
        end
      end

      def attributes
        raise NotImplementedError, "#{self.class} must implement #attributes"
      end

      private

      def coerce_to_h(val)
        return val.to_h if val.is_a?(Serializable)
        return val.map { |item| coerce_to_h(item) } if val.is_a?(Array)
        # Typed maps (additionalProperties): recurse values, preserving the dynamic string keys.
        return val.transform_values { |item| coerce_to_h(item) } if val.is_a?(Hash)

        val
      end
    end
  end
end
