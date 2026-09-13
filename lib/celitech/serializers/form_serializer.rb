# frozen_string_literal: true

require 'uri'

module Celitech
  module Serializers
    # Serializes models or hashes to form-encoded and multipart bodies.
    module Form
      # Encodes a model or hash as application/x-www-form-urlencoded.
      def self.to_urlencoded(value)
        URI.encode_www_form(flatten(value))
      end

      # Configures a Net::HTTP request for multipart/form-data.
      def self.set_multipart(request, value)
        request.set_form(
          flatten(value).map { |k, v| [k.to_s, v.to_s] },
          'multipart/form-data',
        )
      end

      private_class_method def self.flatten(value)
        value = value.value if value.is_a?(Models::UnionType)
        if value.is_a?(Models::Serializable)
          declared = value.class.wire_keys.filter_map do |attr, key|
            val = value.attributes[attr]
            # Form encoding cannot represent null; both UNSET and explicit nil are omitted.
            # Unlike JSON (which serializes nil as null), form bodies have no null concept.
            [key, val] unless val.nil? || val.equal?(Models::UNSET)
          end
          extras = value.is_a?(Models::OpenModel) ? value.open_model_extras.compact.to_a : []
          declared + extras
        elsif value.is_a?(Hash)
          value.compact.to_a
        else
          [['body', value.to_s]]
        end
      end
    end
  end
end
