# frozen_string_literal: true

module Celitech
  module Internal
    module Http
      # Decoding a 2xx body. The service methods decide WHICH schema applies from the DECLARED
      # status code and media type; this holds the one runtime question they cannot answer at
      # generation time: whether there is a body at all.
      #
      # A status declaring several media types is dispatched on the declaration too, so the
      # response's actual `Content-Type` is deliberately not consulted here. The reasoning is in
      # `buildFernDeserializeExpression`: the alternative needs a union return type in a
      # statically-typed sibling language, and trusting the declaration is what keeps a body the
      # server mislabelled parseable.
      #
      # @api private
      module ResponseBody
        # Yields the body for decoding, or returns nil when there is nothing to decode.
        #
        # A 2xx with an empty body is not an error — a server is entitled to answer a declared 200
        # with no content — but handing "" or nil to a JSON parse raises from inside the SDK
        # (`TypeError: no implicit conversion of nil into String`, or `JSON::ParserError` on the
        # empty string), which is the failure this guards.
        # @param response [Net::HTTPResponse] The HTTP response.
        # @return [Object, nil] The block's value, or nil for an absent body.
        def self.decode(response)
          body = response.body
          return nil if body.nil? || body.empty?

          yield body
        end
      end
    end
  end
end
