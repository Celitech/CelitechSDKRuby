# frozen_string_literal: true

module Celitech
  module Models
    class ListPackagesOkResponse
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          packages: 'packages',
          after_cursor: 'afterCursor',
        }.freeze
      end

      def packages
        val = @packages
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def after_cursor
        val = @after_cursor
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        packages: ::Celitech::Models::UNSET,
        after_cursor: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @packages = packages
        @after_cursor = after_cursor
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          packages: hash.fetch('packages', ::Celitech::Models::UNSET),
          after_cursor: hash.fetch('afterCursor', ::Celitech::Models::UNSET),
          additional_properties: hash.except('packages', 'afterCursor'),
        )
      end

      def attributes
        {
          packages: @packages,
          after_cursor: @after_cursor,
        }
      end

      def validate!
        @packages&.each { |item| item.validate! if item.respond_to?(:validate!) } unless @packages.equal?(::Celitech::Models::UNSET)
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
