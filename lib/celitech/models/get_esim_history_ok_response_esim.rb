# frozen_string_literal: true

module Celitech
  module Models
    class GetEsimHistoryOkResponseEsim
      include ::Celitech::Models::Serializable
      include ::Celitech::Models::OpenModel

      def self.wire_keys
        {
          iccid: 'iccid',
          history: 'history',
        }.freeze
      end

      def iccid
        val = @iccid
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      def history
        val = @history
        val.equal?(::Celitech::Models::UNSET) ? nil : val
      end

      attr_reader :additional_properties

      def initialize(iccid: ::Celitech::Models::UNSET, history: ::Celitech::Models::UNSET, additional_properties: {})
        @iccid = iccid
        @history = history
        @additional_properties = additional_properties
      end

      def self.from_hash(hash)
        return unless hash

        new(
          iccid: hash.fetch('iccid', ::Celitech::Models::UNSET),
          history: hash.fetch('history', ::Celitech::Models::UNSET),
          additional_properties: hash.except('iccid', 'history'),
        )
      end

      def attributes
        {
          iccid: @iccid,
          history: @history,
        }
      end

      def validate!
        Validator.validate_string!(@iccid, 'iccid', min_length: 18, max_length: 22) unless @iccid.equal?(::Celitech::Models::UNSET)
        @history&.each { |item| item.validate! if item.respond_to?(:validate!) } unless @history.equal?(::Celitech::Models::UNSET)
      end

      def open_model_extras
        @additional_properties
      end
    end
  end
end
