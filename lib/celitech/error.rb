# frozen_string_literal: true

module Celitech
  class Error < StandardError; end

  class APIError < Error
    attr_reader :status, :body, :headers

    def initialize(status, body, headers = {})
      @status  = status
      @body    = body
      @headers = headers || {}
      super("HTTP #{status}: #{body}")
    end
  end

  class TimeoutError < Error
    def initialize(msg = 'Request timed out')
      super
    end
  end

  # The request never reached the server: connection refused, host unresolvable, socket closed by
  # the peer, or a failed TLS handshake. The underlying transport exception is on `#cause`.
  class ConnectionError < Error
    def initialize(msg = 'Failed to connect')
      super
    end
  end

  class ValidationError < Error
    attr_reader :field, :validation_message

    def initialize(field, message)
      @field              = field
      @validation_message = message
      super("Validation failed for #{field}: #{message}")
    end
  end

  class BadRequestError < APIError
    attr_reader :data

    def initialize(status, data, body, headers = {})
      super(status, body, headers)
      @data = data
    end
  end

  class UnauthorizedError < APIError
    attr_reader :data

    def initialize(status, data, body, headers = {})
      super(status, body, headers)
      @data = data
    end
  end
end
