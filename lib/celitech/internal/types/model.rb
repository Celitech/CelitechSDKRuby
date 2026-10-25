# frozen_string_literal: true

module Celitech
  module Internal
    module Types
      # @abstract
      #
      # An abstract model that all data objects will inherit from
      class Model
        include Type

        class << self
          # The defined fields for this model
          #
          # @api private
          #
          # @return [Hash<Symbol, Field>]
          def fields
            @fields ||= if self < ::Celitech::Internal::Types::Model
                          superclass.fields.dup
                        else
                          {}
                        end
          end

          # Any extra fields that have been created from instantiation
          #
          # @api private
          #
          # @return [Hash<Symbol, Field>]
          def extra_fields
            @extra_fields ||= {}
          end

          # Define a new field on this model
          #
          # @param name [Symbol] The name of the field
          # @param type [Class] Type of the field
          # @option optional [Boolean] If it is an optional field
          # @option nullable [Boolean] If it is a nullable field
          # @option api_name [Symbol, String] Name in the API of this field. When serializing/deserializing, will use
          #   this field name
          # @return [void]
          def field(name, type, optional: false, nullable: false, api_name: nil, default: nil)
            add_field_definition(name: name, type: type, optional: optional, nullable: nullable, api_name: api_name,
                                 default: default)

            define_accessor(name)
            define_setter(name)
          end

          # Define a new literal for this model
          #
          # @param name [Symbol]
          # @param value [Object]
          # @option api_name [Symbol, String]
          # @return [void]
          def literal(name, value, api_name: nil)
            add_field_definition(name: name, type: value.class, optional: false, nullable: false, api_name: api_name,
                                 value: value)

            define_accessor(name)
          end

          # Adds a new field definition into the class's extra fields registry
          #
          # @api private
          #
          # @param name [Symbol]
          # @param type [Class]
          # @option required [Boolean]
          # @option optional [Boolean]
          # @return [void]
          def add_extra_field_definition(name:, type:)
            return if extra_fields.key?(name.to_sym)

            extra_fields[name.to_sym] = Field.new(name: name, type: type, optional: true, nullable: false)

            define_accessor(name)
            define_setter(name)
          end

          def coerce(value, strict: (respond_to?(:strict?) ? strict? : false))
            return value if value.is_a?(self)

            return value unless value.is_a?(::Hash)

            new(value)
          end

          def load(str)
            coerce(::JSON.parse(str, symbolize_names: true))
          end

          def ===(instance)
            instance.class.ancestors.include?(self)
          end

          private

          # Adds a new field definition into the class's fields registry
          #
          # @api private
          #
          # @param name [Symbol]
          # @param type [Class]
          # @option optional [Boolean]
          # @return [void]
          def add_field_definition(name:, type:, optional:, nullable:, api_name:, default: nil, value: nil)
            fields[name.to_sym] =
              Field.new(name: name, type: type, optional: optional, nullable: nullable, api_name: api_name,
                        value: value, default: default)
          end

          # @api private
          def define_accessor(name)
            method_name = name.to_sym

            define_method(method_name) do
              @data[name]
            end
          end

          # @api private
          def define_setter(name)
            method_name = :"#{name}="

            define_method(method_name) do |val|
              @data[name] = val
            end
          end
        end

        # Creates a new instance of this model
        # TODO: Should all this logic be in `#coerce` instead?
        #
        # @param values [Hash]
        # @option strict [Boolean]
        # @return [self]
        def initialize(values = {})
          @data = {}

          values = Utils.symbolize_keys(values.dup)

          self.class.fields.each do |field_name, field|
            # Presence, not truthiness: `values[key]` cannot tell "absent" from "explicitly nil",
            # and `to_h` needs that distinction — an explicit null is "delete this field" to a
            # `merge-patch` endpoint, while an absent one must stay absent.
            provided_key = [field.api_name.to_sym, field.api_name, field_name].find { |key| values.key?(key) }
            value = provided_key.nil? ? nil : values.delete(provided_key)

            # Presence again, not truthiness: `value || default` replaced an explicitly-passed
            # `false` with the literal/default, `false` being falsy in Ruby. An explicit nil now
            # wins over the default too — asking for null is not asking for the default.
            field_value = if !provided_key.nil?
                            value
                          elsif field.literal?
                            field.value
                          elsif field.default
                            field.default
                          end

            # An optional field the caller never mentioned is left OUT of `@data` rather than
            # materialized as an explicit nil, which `to_h` would have serialized as `null`.
            next if provided_key.nil? && field_value.nil? && field.optional

            @data[field_name] = Utils.coerce(field.type, field_value)
          end

          # Any remaining values in the input become extra fields
          values.each do |name, value|
            self.class.add_extra_field_definition(name: name, type: value.class)

            @data[name.to_sym] = value
          end
        end

        def to_h
          result = self.class.fields.merge(self.class.extra_fields).each_with_object({}) do |(name, field), acc|
            # Keyed on PRESENCE first, then on nullability:
            #   absent                     -> omitted, for the reason `initialize` gives above
            #   explicit nil, nullable     -> `null`; that is exactly what the caller asked for
            #   explicit nil, NOT nullable -> omitted; the declared schema forbids null

            value = @data[name]

            next if field.optional && !@data.key?(name)
            next if value.nil? && field.optional && !field.nullable

            acc[field.api_name] = serialize_value(value)
          end

          # Inject union discriminant if this instance was coerced from a discriminated union
          # and the discriminant key is not already present in the result
          discriminant_key = instance_variable_get(:@_fern_union_discriminant_key)
          discriminant_value = instance_variable_get(:@_fern_union_discriminant_value)
          result[discriminant_key] = discriminant_value if discriminant_key && discriminant_value && !result.key?(discriminant_key)

          result
        end

        def ==(other)
          self.class == other.class && to_h == other.to_h
        end

        # @return [String]
        def inspect
          attrs = @data.map do |name, value|
            field = self.class.fields[name] || self.class.extra_fields[name]
            display_value = field&.sensitive? ? '[REDACTED]' : value.inspect
            "#{name}=#{display_value}"
          end

          "#<#{self.class.name}:0x#{object_id&.to_s(16)} #{attrs.join(' ')}>"
        end

        private

        # `::Hash#to_h` returns itself rather than recursing, so a model nested inside a
        # dictionary-typed field's VALUES (not just a direct model field) needs an explicit
        # recursive walk here rather than the bare `value.to_h` this used to do. `Symbol` is
        # handled the same way: enum members are coerced to `Symbol` on the way in
        # (`Internal::Types::Enum#coerce`) so they round-trip through `==`/`Set` lookups, but the
        # wire shape is always the original string value.
        def serialize_value(value)
          case value
          when ::Symbol
            value.to_s
          when ::Array
            value.map { |item| serialize_value(item) }
          when ::Hash
            value.transform_values { |item| serialize_value(item) }
          else
            # `respond_to?(:to_h)`, not `is_a?(Model)`: a free-form/`any`-typed field can hold
            # whatever a caller constructs it with, not only this SDK's own model classes --
            # `Struct`, `OpenStruct`, `Data`, and similar objects respond to `#to_h` too, and
            # narrowing to `Model` would silently fall through to `#to_s` in `JSON.generate` for
            # any of them. `Model#to_h` itself routes back through this same method for every
            # field, so a nested `Model` value still serializes correctly through this branch.
            !value.nil? && value.respond_to?(:to_h) ? value.to_h : value
          end
        end
      end
    end
  end
end
