# frozen_string_literal: true

module Celitech
  module Models
    class ListPurchasesOkResponse
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          purchases: 'purchases',
          after_cursor: 'afterCursor',
        }.freeze
      end

      def purchases
        val = @purchases
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def after_cursor
        val = @after_cursor
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        purchases: ::Celitech::Models::UNSET,
        after_cursor: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @purchases = purchases
        @after_cursor = after_cursor
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          purchases: hash.fetch('purchases', ::Celitech::Models::UNSET),
          after_cursor: hash.fetch('afterCursor', ::Celitech::Models::UNSET),
          additional_properties: hash.except('purchases', 'afterCursor'),
        )
      end

      def attributes
        {
          purchases: @purchases,
          after_cursor: @after_cursor,
        }
      end

      def validate!
        @purchases&.each { |item| item.validate! if item.respond_to?(:validate!) } unless @purchases.equal?(::Celitech::Models::UNSET)
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
