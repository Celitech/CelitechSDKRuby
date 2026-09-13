# frozen_string_literal: true

module Celitech
  module Models
    class CreatePurchaseOkResponse
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          purchase: 'purchase',
          profile: 'profile',
        }.freeze
      end

      def purchase
        val = @purchase
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def profile
        val = @profile
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(purchase: ::Celitech::Models::UNSET, profile: ::Celitech::Models::UNSET, additional_properties: {})
        @purchase = purchase
        @profile = profile
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          purchase:
            hash.key?('purchase') ? ::Celitech::Models::CreatePurchaseOkResponsePurchase.from_hash(hash['purchase']) : ::Celitech::Models::UNSET,
          profile:
            hash.key?('profile') ? ::Celitech::Models::CreatePurchaseOkResponseProfile.from_hash(hash['profile']) : ::Celitech::Models::UNSET,
          additional_properties: hash.except('purchase', 'profile'),
        )
      end

      def attributes
        {
          purchase: @purchase,
          profile: @profile,
        }
      end

      def validate!
        @purchase&.validate! if !@purchase.equal?(::Celitech::Models::UNSET) && @purchase.respond_to?(:validate!)
        @profile&.validate! if !@profile.equal?(::Celitech::Models::UNSET) && @profile.respond_to?(:validate!)
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
