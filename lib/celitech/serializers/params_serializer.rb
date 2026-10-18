# frozen_string_literal: true

require 'json'
require 'uri'

module Celitech
  module Serializers
    # Serializes parameters using OpenAPI-defined styles for query and path parameters.
    module Params
      # Returns an array of "key=value" strings for the given query parameter.
      # Returns an empty array if +value+ is nil.
      def self.query_part(key, value, style = :form, explode: true)
        value = normalize(value)
        return [] if value.nil?

        case style
        when :space_delimited then space_delimited_parts(key, value, explode)
        when :pipe_delimited  then pipe_delimited_parts(key, value, explode)
        when :deep_object     then deep_object_parts(key, value)
        else                       form_parts(key, value, explode)
        end
      end

      # Serializes a path parameter using the "simple" style (RFC 6570 §3.2.2), which is the
      # OpenAPI default for a path parameter. A scalar is percent-encoded; an array is comma
      # joined (+explode+ does not change simple-style arrays); an object is comma joined as
      # "key,value" pairs, or as "key=value" pairs when exploded.
      def self.simple(value, explode: false)
        value = normalize(value)
        return '' if value.nil?

        if value.is_a?(Array)
          value.compact.map { |v| encode(v) }.join(',')
        elsif value.is_a?(Hash)
          pairs = value.compact
          if explode
            pairs.map { |k, v| "#{encode(k)}=#{encode(v)}" }.join(',')
          else
            pairs.flat_map { |k, v| [encode(k), encode(v)] }.join(',')
          end
        else
          encode(value)
        end
      end

      # Serializes a path parameter using the "label" style (RFC 6570 §3.2.5).
      def self.label(value, explode: false)
        value = normalize(value)
        return '' if value.nil?

        if value.is_a?(Array)
          values = value.compact
          return '' if values.empty?

          explode ? values.map { |v| ".#{encode(v)}" }.join : ".#{values.map { |v| encode(v) }.join(',')}"
        elsif value.is_a?(Hash)
          return '' if value.empty?

          if explode
            parts = value.filter_map { |k, v| "#{encode(k)}=#{encode(v)}" unless v.nil? }
            parts.empty? ? '' : ".#{parts.join('.')}"
          else
            parts = value.filter_map { |k, v| [encode(k), encode(v)] unless v.nil? }.flatten
            parts.empty? ? '' : ".#{parts.join(',')}"
          end
        else
          ".#{encode(value)}"
        end
      end

      # Serializes a path parameter using the "matrix" style (RFC 6570 §3.2.7).
      def self.matrix(key, value, explode: false)
        value = normalize(value)
        return '' if value.nil?

        if value.is_a?(Array)
          values = value.compact
          return '' if values.empty?

          if explode
            values.map { |v| ";#{key}=#{encode(v)}" }.join
          else
            ";#{key}=#{values.map { |v| encode(v) }.join(',')}"
          end
        elsif value.is_a?(Hash)
          return '' if value.empty?

          if explode
            parts = value.filter_map { |k, v| ";#{encode(k)}=#{encode(v)}" unless v.nil? }
            parts.empty? ? '' : parts.join
          else
            parts = value.filter_map { |k, v| [encode(k), encode(v)] unless v.nil? }.flatten
            parts.empty? ? '' : ";#{key}=#{parts.join(',')}"
          end
        else
          ";#{key}=#{encode(value)}"
        end
      end

      private_class_method def self.form_parts(key, value, explode)
        if value.is_a?(Array)
          values = value.compact
          return [] if values.empty?

          if explode
            values.map { |v| "#{encode(key)}=#{encode(v)}" }
          else
            ["#{encode(key)}=#{values.map { |v| encode(v) }.join(',')}"]
          end
        elsif value.is_a?(Hash)
          return [] if value.empty?

          if explode
            value.filter_map { |k, v| "#{encode(k)}=#{encode(v)}" unless v.nil? }
          else
            parts = value.filter_map { |k, v| [encode(k), encode(v)] unless v.nil? }.flatten
            parts.empty? ? [] : ["#{encode(key)}=#{parts.join(',')}"]
          end
        else
          ["#{encode(key)}=#{encode(value)}"]
        end
      end

      private_class_method def self.space_delimited_parts(key, value, explode)
        return form_parts(key, value, true) if explode
        return [] unless value.is_a?(Array)

        values = value.compact
        values.empty? ? [] : ["#{encode(key)}=#{values.map { |v| encode(v) }.join('%20')}"]
      end

      private_class_method def self.pipe_delimited_parts(key, value, explode)
        return form_parts(key, value, true) if explode
        return [] unless value.is_a?(Array)

        values = value.compact
        # Pipe delimiter is intentionally not percent-encoded per the OpenAPI spec.
        values.empty? ? [] : ["#{encode(key)}=#{values.map { |v| encode(v) }.join('|')}"]
      end

      private_class_method def self.deep_object_parts(key, value)
        return [] unless value.is_a?(Hash)

        value.filter_map { |k, v| "#{encode(key)}[#{encode(k)}]=#{encode(v)}" unless v.nil? }
      end

      # Reduces a declared parameter value to the plain Ruby shape the styles above are defined
      # over: a union to its member, a model to its wire Hash. Without this a model reaches
      # #encode as an object and is stringified by Ruby's #inspect, which puts a memory address
      # on the wire instead of the caller's data.
      private_class_method def self.normalize(value)
        value = value.value if value.is_a?(Models::UnionType)
        return to_hash(value) if value.is_a?(Models::Serializable)

        value
      end

      # Percent-encodes a value using RFC 3986. Spaces are encoded as %20 (not +)
      # so the result is safe for both query strings and path segments.
      private_class_method def self.encode(value)
        # Normalizing again here is for a nested MODEL leaf: the entry points above reduce only the
        # top-level value, so a model held inside a Hash/Array reaches #encode unreduced. It cannot
        # be deferred into the JSON branch below, because that branch's own test — "is this a
        # ::Hash/::Array?" — is only true once the model has been reduced to one. The repeat pass
        # on an already-plain value is two #is_a? checks; #to_hash runs only for a real model.
        value = normalize(value)
        # A style is defined over scalars, a flat array and a flat object only — OpenAPI says
        # nothing about what a nested array/object leaf looks like. JSON is emitted for it so the
        # caller's data survives, rather than Ruby's Array#to_s / Hash#to_s rendering.
        value = ::JSON.generate(value) if value.is_a?(::Hash) || value.is_a?(::Array)
        URI.encode_www_form_component(value.to_s).gsub('+', '%20')
      end

      private_class_method def self.to_hash(serializable)
        serializable.class.wire_keys.each_with_object({}) do |(attr, key), h|
          val = serializable.attributes[attr]
          h[key] = val unless val.nil? || val.equal?(Models::UNSET)
        end
      end
    end
  end
end
