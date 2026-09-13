# frozen_string_literal: true

module Celitech
  module Models
    class CreatePurchaseV2OkResponsePurchase
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          id: 'id',
          package_id: 'packageId',
          created_date: 'createdDate',
        }.freeze
      end

      def id
        val = @id
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def package_id
        val = @package_id
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def created_date
        val = @created_date
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(
        id: ::Celitech::Models::UNSET,
        package_id: ::Celitech::Models::UNSET,
        created_date: ::Celitech::Models::UNSET,
        additional_properties: {}
      )
        @id = id
        @package_id = package_id
        @created_date = created_date
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          id: hash.fetch('id', ::Celitech::Models::UNSET),
          package_id: hash.fetch('packageId', ::Celitech::Models::UNSET),
          created_date: hash.fetch('createdDate', ::Celitech::Models::UNSET),
          additional_properties: hash.except('id', 'packageId', 'createdDate'),
        )
      end

      def attributes
        {
          id: @id,
          package_id: @package_id,
          created_date: @created_date,
        }
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
