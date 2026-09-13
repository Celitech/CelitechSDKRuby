# frozen_string_literal: true

module Celitech
  module HTTP
    # Lifecycle hooks for intercepting HTTP requests and responses.
    # Override these methods in a subclass to add custom behaviour.
    # Hook implementations should not raise exceptions; uncaught errors
    # will propagate out of the connection and bypass subsequent hooks.
    class Hooks
      def before_request(request, params = {}); end

      def after_response(request, response, params = {}); end

      def on_error(error, request, params = {}); end
    end
  end
end
