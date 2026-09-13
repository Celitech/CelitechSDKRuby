# frozen_string_literal: true

module Celitech
  module Validator
    class << self
      def validate_string!(value, field, min_length: nil, max_length: nil, pattern: nil)
        return if value.nil?

        raise ValidationError.new(field, "must be at least #{min_length} characters long") if min_length && value.to_s.length < min_length
        raise ValidationError.new(field, "must be at most #{max_length} characters long") if max_length && value.to_s.length > max_length
        return unless pattern && !value.to_s.match?(pattern)

        raise ValidationError.new(field, "must match pattern #{pattern.source}")
      end

      def validate_number!(value, field, min: nil, min_exclusive: nil, max: nil, max_exclusive: nil,
                           multiple_of: nil)
        return if value.nil?

        raise ValidationError.new(field, "must be >= #{min}") if min && value < min
        raise ValidationError.new(field, "must be > #{min_exclusive}") if min_exclusive && value <= min_exclusive
        raise ValidationError.new(field, "must be <= #{max}") if max && value > max
        raise ValidationError.new(field, "must be < #{max_exclusive}") if max_exclusive && value >= max_exclusive
        return unless multiple_of && (value % multiple_of).abs > Float::EPSILON * multiple_of.abs

        raise ValidationError.new(field, "must be a multiple of #{multiple_of}")
      end

      alias validate_integer! validate_number!

      def validate_array!(value, field, min_items: nil, max_items: nil, unique_items: false)
        return if value.nil?

        raise ValidationError.new(field, "must have at least #{min_items} items") if min_items && value.length < min_items
        raise ValidationError.new(field, "must have at most #{max_items} items") if max_items && value.length > max_items
        return unless unique_items && value.length != value.uniq.length

        raise ValidationError.new(field, 'must contain unique items')
      end
    end
  end
end
