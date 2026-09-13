# frozen_string_literal: true

require 'json'

module Celitech
  module Serializers
    # Serializes models to JSON-ready hashes and deserializes hashes back to models.
    module Json
      # Converts a model, array, or primitive to a plain Ruby hash/value
      # suitable for JSON.generate / .to_json.
      def self.serialize(value)
        return value.map { |item| serialize(item) } if value.is_a?(Array)
        # Typed maps (additionalProperties): serialize values, keeping the dynamic string keys.
        return value.transform_values { |item| serialize(item) } if value.is_a?(Hash)
        return serialize(value.value) if value.is_a?(Models::UnionType)
        return serialize_model(value) if value.is_a?(Models::Serializable)

        value
      end

      # Builds a model instance from a plain hash (already JSON.parsed).
      # Returns the raw data unchanged when no model class is provided.
      def self.deserialize(data, model_class = nil)
        return data unless model_class

        model_class.from_hash(data)
      end

      private_class_method def self.serialize_model(model)
        result = model.class.wire_keys.each_with_object({}) do |(attr, key), hash|
          val = model.attributes[attr]
          next if val.equal?(Models::UNSET)

          hash[key] = serialize(val)
        end
        model.open_model_extras.each { |k, v| result[k] = serialize(v) unless result.key?(k) } if model.is_a?(Models::OpenModel)
        result
      end
    end
  end
end
