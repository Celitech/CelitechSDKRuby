# frozen_string_literal: true

module Celitech
  module Errors
    # A 5xx response.
    class ServerError < ResponseError
    end

    class InternalServerError < ServerError
    end

    class BadGatewayError < ServerError
    end

    # Was `< ApiError`, which is not a ResponseError and so takes no `code:` — a 503 therefore
    # raised `ArgumentError: wrong number of arguments` from the raise site itself, and the typed
    # error was unreachable. It is also now inside the 5xx subtree, so `rescue ServerError`
    # catches it.
    class ServiceUnavailableError < ServerError
    end

    class GatewayTimeoutError < ServerError
    end
  end
end
