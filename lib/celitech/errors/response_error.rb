# frozen_string_literal: true

module Celitech
  module Errors
    # An error returned by the API. The raw response body is the exception message and the HTTP
    # status code is available via #code, as before; #body adds the body deserialized into the
    # type the spec declares for that status, so a field the spec declares on an error response is
    # reachable as `error.body.retry_after_seconds` instead of only by parsing #message by hand.
    #
    # #body is nil when the response carried no body, or a body that is not the declared shape.
    class ResponseError < ApiError
      attr_reader :code, :body

      # @param msg [String] The raw response body.
      # @param code [Integer] The HTTP status code.
      # @param body [Object, nil] The deserialized error body.
      def initialize(msg, code:, body: nil)
        @code = code
        @body = body
        super(msg)
      end

      # Deserializes a raw error body with +type+, or nil when there is nothing to deserialize or
      # the body is not the declared shape.
      #
      # An error response is the one place a server is most likely to answer off-spec — an HTML
      # page from a proxy, an empty 500, a plain-text gateway message — and a raise site must not
      # turn that into a parse failure that hides the status code the caller needs. So this
      # rescues and degrades to nil rather than propagating.
      #
      # @param raw [String, nil] The raw response body.
      # @param type [Class, nil] The model declared for this status, or nil if none is.
      # @return [Object, nil]
      def self.load_body(raw, type)
        return nil if type.nil? || raw.nil? || raw.to_s.strip.empty?

        parsed = type.load(raw)
        deserialized?(parsed) ? parsed : nil
      rescue StandardError
        nil
      end

      # True when +load+ actually deserialized the body into the declared type, rather than handing
      # back the raw parsed JSON — which is what it does for an off-spec body, since a model's
      # #coerce returns a non-Hash untouched and a union's returns a value matching no member
      # untouched.
      #
      # This deliberately does NOT ask +is_a?(type)+. A oneOf/anyOf error model is generated as a
      # MODULE and its +load+ returns the matching MEMBER, whose class does not include that
      # module, so +is_a?+ is false for every VALID union body; an enum's +load+ returns a Symbol,
      # which is likewise not an instance of the enum. Both would have silently nil'd #body.
      # Everything successfully deserialized is a model instance or an enum's Symbol, and neither
      # is a shape ::JSON.parse can produce on its own.
      private_class_method def self.deserialized?(value)
        value.is_a?(Internal::Types::Model) || value.is_a?(::Symbol)
      end

      def inspect
        "#<#{self.class.name} @code=#{code} @body=#{message}>"
      end

      # Maps an HTTP status code to the most specific error subclass. Status-specific classes come
      # first so a caller can rescue the exact response the spec declares; the range classes are
      # the fallback for a status without one.
      #
      # Resolved inside the method body rather than from a constant map, so the subclasses only
      # have to be loaded by the time a request actually fails, not by the time this file is read.
      def self.subclass_for_code(code)
        case code
        when 300..399 then RedirectError
        when 400 then BadRequestError
        when 401 then UnauthorizedError
        when 402 then PaymentRequiredError
        when 403 then ForbiddenError
        when 404 then NotFoundError
        when 405 then MethodNotAllowedError
        when 409 then ConflictError
        when 415 then UnsupportedMediaTypeError
        when 422 then UnprocessableEntityError
        when 429 then TooManyRequestsError
        when 400..499 then ClientError
        when 500 then InternalServerError
        when 502 then BadGatewayError
        when 503 then ServiceUnavailableError
        when 504 then GatewayTimeoutError
        when 500..599 then ServerError
        else ResponseError
        end
      end
    end
  end
end
