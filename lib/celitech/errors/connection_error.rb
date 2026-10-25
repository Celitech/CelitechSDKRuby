# frozen_string_literal: true

module Celitech
  module Errors
    # Raised when the request never reached the server: the connection was refused, the host could
    # not be resolved, the peer closed the socket, or the TLS handshake failed. The underlying
    # transport exception is available on `#cause`.
    class ConnectionError < ApiError
    end
  end
end
