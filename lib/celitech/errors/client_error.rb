# frozen_string_literal: true

module Celitech
  module Errors
    # A 4xx response.
    class ClientError < ResponseError
    end

    # One class per status a spec commonly declares, so a caller can rescue the exact response
    # rather than the whole 4xx range. A 400 and a 422 are different failures — a malformed
    # request against a well-formed one the server refuses — and collapsing them onto ClientError
    # left no way to branch on which had happened. Any other 4xx still falls back to ClientError.
    class BadRequestError < ClientError
    end

    class UnauthorizedError < ClientError
    end

    class PaymentRequiredError < ClientError
    end

    class ForbiddenError < ClientError
    end

    class NotFoundError < ClientError
    end

    class MethodNotAllowedError < ClientError
    end

    class ConflictError < ClientError
    end

    class UnsupportedMediaTypeError < ClientError
    end

    class UnprocessableEntityError < ClientError
    end

    class TooManyRequestsError < ClientError
    end
  end
end
