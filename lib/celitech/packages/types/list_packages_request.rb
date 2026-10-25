# frozen_string_literal: true

module Celitech
  module Packages
    module Types
      class ListPackagesRequest < ::Celitech::Internal::Types::Model
        field :destination, -> { String }, optional: true, nullable: false

        field :data_limit_in_gb, -> { Float }, optional: true, nullable: false, api_name: 'dataLimitInGB'

        field :start_date, -> { String }, optional: true, nullable: false, api_name: 'startDate'

        field :end_date, -> { String }, optional: true, nullable: false, api_name: 'endDate'

        field :after_cursor, -> { String }, optional: true, nullable: false, api_name: 'afterCursor'

        field :limit, -> { Float }, optional: true, nullable: false

        field :start_time, -> { Integer }, optional: true, nullable: false, api_name: 'startTime'

        field :end_time, -> { Integer }, optional: true, nullable: false, api_name: 'endTime'

        field :include_unlimited, -> { ::Celitech::Internal::Types::Boolean }, optional: true, nullable: false, api_name: 'includeUnlimited'
      end
    end
  end
end
