# frozen_string_literal: true

module Celitech
  module ESim
    module Types
      class GetEsimDeviceResponseDevice < ::Celitech::Internal::Types::Model
        field :oem, -> { String }, optional: false, nullable: false
        field :hardware_name, -> { String }, optional: false, nullable: false, api_name: 'hardwareName'
        field :hardware_model, -> { String }, optional: false, nullable: false, api_name: 'hardwareModel'
        field :eid, -> { String }, optional: false, nullable: false

        def self.load(str)
          coerce(::JSON.parse(str, symbolize_names: true))
        end

        def self.dump(value)
          coerced = coerce(value)
          ::JSON.generate(coerced.nil? || !coerced.respond_to?(:to_h) ? coerced : coerced.to_h)
        end
      end
    end
  end
end
