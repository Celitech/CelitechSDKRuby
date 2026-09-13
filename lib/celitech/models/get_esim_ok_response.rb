# frozen_string_literal: true

module Celitech
  module Models
    class GetEsimOkResponse
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          esim: 'esim',
        }.freeze
      end

      def esim
        val = @esim
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(esim: ::Celitech::Models::UNSET, additional_properties: {})
        @esim = esim
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          esim:
            hash.key?('esim') ? ::Celitech::Models::GetEsimOkResponseEsim.from_hash(hash['esim']) : ::Celitech::Models::UNSET,
          additional_properties: hash.except('esim'),
        )
      end

      def attributes
        {
          esim: @esim,
        }
      end

      def validate!
        @esim&.validate! if !@esim.equal?(::Celitech::Models::UNSET) && @esim.respond_to?(:validate!)
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
