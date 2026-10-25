# frozen_string_literal: true

module Celitech
  module Internal
    module Types
      # Define a union between two types
      module Union
        include ::Celitech::Internal::Types::Type

        def members
          @members ||= []
        end

        # Add a member to this union
        #
        # @param type [Object]
        # @option key [Symbol, String]
        # @return [void]
        def member(type, key: nil)
          members.push([key, Utils.wrap_type(type)])
          self
        end

        def type_member?(type)
          members.any? { |_key, type_fn| type == type_fn.call }
        end

        # Set the discriminant for this union
        #
        # @param key [Symbol, String]
        # @return [void]
        def discriminant(key)
          @discriminant = key
        end

        def coerce(value, strict: strict?)
          type = resolve_member(value)

          unless type
            return value unless strict

            if discriminated?
              raise Errors::TypeError,
                    "value of type `#{value.class}` not member of union #{self}"
            end

            raise Errors::TypeError, "could not resolve to member of union #{self}"
          end

          coerced = Utils.coerce(type, value, strict: strict)

          # For discriminated unions, store the discriminant info on the coerced instance
          # so it can be injected back during serialization (to_h)
          if discriminated? && value.is_a?(::Hash) && coerced.is_a?(Model)
            discriminant_value = value.fetch(@discriminant, nil) || value.fetch(@discriminant.to_s, nil)
            if discriminant_value
              coerced.instance_variable_set(:@_fern_union_discriminant_key, @discriminant.to_s)
              coerced.instance_variable_set(:@_fern_union_discriminant_value, discriminant_value)
            end
          end

          coerced
        end

        # Parse JSON string and coerce to the correct union member type
        #
        # @param str [String] JSON string to parse
        # @return [Object] Coerced value matching a union member
        def load(str)
          coerce(::JSON.parse(str, symbolize_names: true))
        end

        # FSDK-1660: like +load+, but RAISES when the value matches no member instead of handing
        # the raw parsed value back.
        #
        # +load+ returns the value untouched in that case, because +coerce+ only raises under
        # strictness and +strict?+ defaults to false. That is correct for a REQUEST body, where the
        # caller's value is theirs to send. It is wrong for a DECLARED SUCCESS RESPONSE: the
        # method's return type is this union, so a bare ::Hash violates it, and the caller found
        # out through a +NoMethodError+ from +result.field+ a long way from the real cause.
        #
        # Only member RESOLUTION is enforced here. The matched member is coerced exactly as +load+
        # coerces it — non-strict — so nothing that used to deserialize stops deserializing; the
        # only bodies that change behaviour are the ones that produced no typed value at all.
        #
        # Note a generated union module defines its OWN +self.load+, which shadows the one above;
        # this method is unshadowed and is deliberately self-contained rather than delegating, so
        # it does not depend on which +load+ wins.
        #
        # @param str [String] JSON string to parse
        # @return [Object] Coerced value matching a union member
        # @raise [Errors::TypeError] If the value matches no member of this union.
        def load!(str)
          value = ::JSON.parse(str, symbolize_names: true)
          unless resolve_member(value)
            raise Errors::TypeError,
                  "response body could not be resolved to a member of union #{self}"
          end

          coerce(value)
        end

        private

        # @api private
        def discriminated?
          !@discriminant.nil?
        end

        # Check if value matches a type, handling type wrapper instances
        # (Internal::Types::Hash and Internal::Types::Array instances)
        #
        # @param value [Object]
        # @param member_type [Object]
        # @return [Boolean]
        def type_matches?(value, member_type)
          case member_type
          when ::Celitech::Internal::Types::Hash
            value.is_a?(::Hash)
          when ::Celitech::Internal::Types::Array
            value.is_a?(::Array)
          when ::Celitech::Internal::Types::Union
            # A member that is itself a union (Boolean is TrueClass | FalseClass) matches when one
            # of its own members does; nothing includes the module, so +is_a?+ is always false.
            !member_type.send(:resolve_member, value).nil?
          when Class, Module
            value.is_a?(member_type)
          else
            false
          end
        end

        # How many members are Model classes, i.e. candidates for the hash-coercion pass.
        #
        # Memoized: the member list is fixed once the union module is defined, and this would
        # otherwise resolve every member's lambda on every frame a WebSocket channel decodes.
        #
        # @return [Integer]
        def model_member_count
          @model_member_count ||= members.count do |_key, mem|
            member_type = Utils.unwrap_type(mem)
            member_type.is_a?(Class) && member_type <= Model
          end
        end

        # Whether every field the model declares is optional, leaving nothing to discriminate on.
        #
        # @param member_type [Class]
        # @return [Boolean]
        def all_optional_fields?(member_type)
          fields = member_type.fields
          !fields.empty? && fields.each_value.all?(&:optional)
        end

        # Whether this member is one that coerces from ANY hash and the payload gives no sign it is
        # the one meant: every field optional, and none of its own wire keys present.
        #
        # One predicate rather than two so the call site stays a single-statement modifier `if`.
        #
        # @param member_type [Class]
        # @param present_keys [Array<Symbol>]
        # @return [Boolean]
        def lacks_own_key?(member_type, present_keys)
          return false unless all_optional_fields?(member_type)

          member_type.fields.each_value.none? do |field|
            present_keys.include?(field.api_name.to_sym) || present_keys.include?(field.name.to_sym)
          end
        end

        # Resolves the type of a value to be one of the members
        #
        # @param value [Object]
        # @return [Class]
        def resolve_member(value)
          if discriminated? && value.is_a?(::Hash)
            # Try both symbol and string keys for the discriminant
            discriminant_value = value.fetch(@discriminant, nil) || value.fetch(@discriminant.to_s, nil)

            return if discriminant_value.nil?

            # Convert to string for consistent comparison
            discriminant_str = discriminant_value.to_s

            # First try exact match
            members_hash = members.to_h
            result = members_hash[discriminant_str]&.call
            return result if result

            # Try case-insensitive match as fallback
            discriminant_lower = discriminant_str.downcase
            matching_keys = members_hash.keys.select { |k| k.to_s.downcase == discriminant_lower }

            # Only use case-insensitive match if exactly one key matches (avoid ambiguity)
            return members_hash[matching_keys.first]&.call if matching_keys.length == 1

            nil
          else
            # First try exact type matching
            result = members.find do |_key, mem|
              member_type = Utils.unwrap_type(mem)
              type_matches?(value, member_type)
            end&.last&.call

            return result if result

            # For Hash values, try to coerce into Model member types
            if value.is_a?(::Hash)
              present_keys = Utils.symbolize_keys(value).keys
              # With one Model member there is nothing to disambiguate against, so the key check
              # below would only reject a payload that member is the only candidate for.
              several_models = model_member_count > 1
              members.find do |_key, mem|
                member_type = Utils.unwrap_type(mem)
                # Check if member_type is a Model class
                next unless member_type.is_a?(Class) && member_type <= Model

                # A member whose fields are every one optional coerces from ANY hash, so in
                # declaration order it takes every later member's payload. Require the hash to carry
                # at least one of the member's own keys; the required-field check below is what
                # discriminates every other member.
                next false if several_models && lacks_own_key?(member_type, present_keys)

                # Try to coerce the hash into this model type with strict mode
                begin
                  candidate = Utils.coerce(member_type, value, strict: true)

                  # Validate that all required (non-optional) fields are present
                  # This ensures undiscriminated unions properly distinguish between member types
                  member_type.fields.each do |field_name, field|
                    raise Errors::TypeError, "Required field `#{field_name}` missing for union member #{member_type.name}" if candidate.instance_variable_get(:@data)[field_name].nil? && !field.optional
                  end

                  true
                rescue Errors::TypeError
                  false
                end
              end&.last&.call
            end
          end
        end
      end
    end
  end
end
