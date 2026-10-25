# frozen_string_literal: true

# Required here rather than inherited from elsewhere in the load order: this file is the only one
# in the generated runtime that talks to Net::HTTP, and TIMEOUT_ERRORS names its exception classes
# at class-definition time.
require 'net/http'
require 'openssl'
require 'uri'

module Celitech
  module Internal
    module Http
      # @api private
      class RawClient
        # The retry policy this SDK was generated with. Every value is overridable per client via
        # `retry_config:`, and the keys are the ones the rest of the generated SDKs already use
        # (the legacy Ruby `HTTP::Connection` and the Python `RetryHandler`), so there is one shape
        # to learn rather than a Ruby-only third one.
        DEFAULT_RETRY_CONFIG = {
          # Retried status codes. `retry_all_server_errors` covers the open-ended 5xx range that
          # cannot be enumerated.
          status_codes_to_retry: [408, 429].freeze,
          retry_all_server_errors: true,
          # HTTP methods allowed to retry at all. A method absent here is never retried; a method
          # present here is retried only if replaying it is safe (see `#retryable_method?`).
          http_methods_to_retry: %w[GET POST PUT DELETE PATCH HEAD OPTIONS].freeze,
          # Exponential backoff, in milliseconds: delay_ms * (backoff_factor ** attempt), capped at
          # max_delay_ms, plus up to jitter_ms of random jitter.
          delay_ms: 150,
          max_delay_ms: 5_000,
          backoff_factor: 2,
          jitter_ms: 50,
          # Ceiling for a server-directed wait parsed from Retry-After. Separate from max_delay_ms
          # because a server asking for a long wait is legitimate; this only guards against a
          # pathological value.
          max_retry_after_delay_ms: 60_000,
        }.freeze

        # Methods RFC 9110 defines as idempotent: replaying one cannot cause a second effect, so a
        # retry is safe. POST and PATCH are absent deliberately — see `#retryable_method?`.
        IDEMPOTENT_METHODS = %w[GET HEAD PUT DELETE OPTIONS TRACE].freeze

        # Request headers that carry a caller-supplied idempotency key. A server that honours one
        # deduplicates a replay, which is what makes retrying a non-idempotent method safe.
        IDEMPOTENCY_KEY_HEADERS = %w[Idempotency-Key].freeze

        # Net::HTTP's three timeout exceptions, all reachable because `#send` sets open_timeout,
        # read_timeout AND write_timeout. Deliberately not widened to their shared parent
        # `Timeout::Error`, which would also swallow an unrelated `Timeout.timeout` block in caller
        # code.
        # `IO::TimeoutError` is the fourth and is NOT a Net::HTTP class: since Ruby 3.2 an expired
        # connect deadline surfaces from the IO layer, and it descends from IOError rather than
        # Timeout::Error, so none of the three above catch it and CONNECTION_ERRORS excludes bare
        # IOError. Without it a timed-out connect escaped unwrapped on ruby 3.3 -- the version the
        # gemspec floors at and the e2e image runs -- while raising Net::OpenTimeout on 4.x, so it
        # looked correct locally. No `defined?` guard: the gemspec requires >= 3.3.
        TIMEOUT_ERRORS = [::Net::OpenTimeout, ::Net::ReadTimeout, ::Net::WriteTimeout, ::IO::TimeoutError].freeze

        # Failures that mean the request never reached the server. `SocketError` covers DNS
        # resolution (`Socket::ResolutionError` derives from it); `EOFError` is the peer closing
        # mid-exchange; `OpenSSL::SSL::SSLError` is a handshake or certificate failure, which is
        # still a connection that could not be established. Bare `IOError` is deliberately absent:
        # it is broad enough to catch an unrelated failure from a caller-supplied IO body.
        CONNECTION_ERRORS = [
          ::SocketError,
          ::EOFError,
          ::Errno::ECONNREFUSED,
          ::Errno::ECONNRESET,
          ::Errno::ECONNABORTED,
          ::Errno::EHOSTUNREACH,
          ::Errno::ENETUNREACH,
          ::Errno::EPIPE,
          ::Errno::ETIMEDOUT,
          ::OpenSSL::SSL::SSLError,
        ].freeze

        # Both sets, in the order `#wrap_transport_error` classifies them. TIMEOUT_ERRORS is
        # checked first because Net::WriteTimeout is an IOError descendant and would otherwise be
        # ambiguous.
        TRANSPORT_ERRORS = (TIMEOUT_ERRORS + CONNECTION_ERRORS).freeze

        # Open/read/write timeout in seconds when neither the client nor the call names one. Held as
        # a constant rather than a keyword default so the root client can offer a `timeout:` of its
        # own without restating the number.
        DEFAULT_TIMEOUT = 60.0

        # @return [String] The base URL for requests
        attr_reader :base_url

        # @param base_url [String] The base url for the request.
        # @param max_retries [Integer] The number of times to retry a failed request, defaults to 2.
        # @param timeout [Float, nil] The timeout for the request; DEFAULT_TIMEOUT when nil.
        # @param headers [Hash] The headers for the request.
        # @param token_provider [Proc, nil] Optional callable returning the Authorization header
        #   value; invoked on every request so dynamic (OAuth/refresh) credentials stay current.
        # @param retry_config [Hash] Overrides for any key of DEFAULT_RETRY_CONFIG.
        def initialize(base_url:, max_retries: 2, timeout: nil, headers: {}, token_provider: nil, retry_config: {})
          @base_url = base_url
          @max_retries = max_retries
          @timeout = timeout || DEFAULT_TIMEOUT
          @token_provider = token_provider
          @retry_config = DEFAULT_RETRY_CONFIG.merge(retry_config.to_h.transform_keys(&:to_sym))
          @default_headers = {
            'User-Agent': 'postman-codegen/3.12.0 celitech/3.0.0 (ruby)',
            'X-Fern-Language': 'Ruby',
            'X-Fern-SDK-Name': 'celitech',
            'X-Fern-SDK-Version': '3.0.0',
          }.merge(headers)
        end

        # @param request [::Celitech::Internal::Http::BaseRequest] The HTTP request.
        # @return [Net::HTTPResponse] The HTTP response.
        # @raise [::Celitech::Errors::TimeoutError] The request timed out and no retry remained.
        # @raise [::Celitech::Errors::ConnectionError] The request never reached the server.
        def send(request)
          url = build_url(request)
          timeout = resolve_timeout(request)
          attempt = 0
          response = nil

          loop do
            # Refresh the dynamic auth header (OAuth/refresh) before each attempt, if configured.
            @default_headers.merge!(resolve_auth_headers)

            # Encoded ONCE per attempt and then reused for the retry decision. `encode_headers` is
            # not a pure getter — `Multipart::Request` reads its body's content type off the
            # encoder — so asking the request again from inside `should_retry?` re-ran that work on
            # every attempt for no gain.
            headers = request.encode_headers(protected_keys: protected_header_keys)

            http_request = build_http_request(
              url:,
              method: request.method,
              headers:,
              body: request.encode_body,
            )

            begin
              conn = connect(url)
              conn.open_timeout = timeout
              conn.read_timeout = timeout
              conn.write_timeout = timeout
              conn.continue_timeout = timeout

              response = conn.request(http_request)
            rescue *TRANSPORT_ERRORS => e
              raise wrap_transport_error(e) unless retry_transport_error?(request, attempt, headers)

              sleep(retry_delay(nil, attempt))
              attempt += 1
              next
            end

            break unless should_retry?(request, response, attempt, headers)

            delay = retry_delay(response, attempt)
            sleep(delay)
            attempt += 1
          end

          response
        end

        # Performs the request WITHOUT reading its body, and hands the open response to the block.
        #
        # `#send` returns a response whose body Net::HTTP has already buffered in full, which is
        # what every non-streaming method wants and what makes a byte stream impossible: the call
        # does not return until the last byte has arrived. Net::HTTP only streams through the block
        # form of `#request`, and the body has to be read INSIDE that block — the socket is closed
        # when it returns — so this cannot be expressed as a different return value.
        #
        # Retries work the same way as `#send`, and for the same reason they can: the retry decision
        # is made from the status and headers, which arrive before the body. A response the block
        # consumes is never retried, because by then the caller has already seen bytes.
        #
        # @param request [::Celitech::Internal::Http::BaseRequest] The HTTP request.
        # @param headers [Hash] Headers to send in addition to the request's own.
        # @param retryable [Boolean] Whether a failed attempt may be retried under the retry policy.
        # @yieldparam response [Net::HTTPResponse] The response, body unread.
        # @return [void]
        # @raise [::Celitech::Errors::TimeoutError] The request timed out and no retry remained.
        # @raise [::Celitech::Errors::ConnectionError] The request never reached the server.
        def stream(request, headers: {}, retryable: true)
          url = build_url(request)
          timeout = resolve_timeout(request)
          attempt = 0
          extra_headers = headers

          loop do
            @default_headers.merge!(resolve_auth_headers)
            headers = request.encode_headers(protected_keys: protected_header_keys).merge(extra_headers)

            http_request = build_http_request(
              url:,
              method: request.method,
              headers:,
              body: request.encode_body,
            )

            # The response to take Retry-After from, set only when this attempt is being retried.
            # It cannot be read after the block returns -- the socket is closed by then -- so the
            # decision and the directive are both taken inside it.
            retry_from = nil
            # Whether the caller has been handed the response. A read that fails AFTER that is not
            # replayable: the consumer already has bytes, so re-sending would duplicate them.
            consumed = false
            begin
              conn = connect(url)
              conn.open_timeout = timeout
              conn.read_timeout = timeout
              conn.write_timeout = timeout
              conn.continue_timeout = timeout

              conn.request(http_request) do |response|
                if retryable && should_retry?(request, response, attempt, headers)
                  # The body is left unread: Net::HTTP discards it when this block returns, and
                  # reading it would be pointless work on a response nobody will see.
                  retry_from = response
                else
                  consumed = true
                  yield response
                end
              end
            rescue *TRANSPORT_ERRORS => e
              raise wrap_transport_error(e) if consumed || !retryable
              raise wrap_transport_error(e) unless retry_transport_error?(request, attempt, headers)

              sleep(retry_delay(nil, attempt))
              attempt += 1
              next
            end

            return if retry_from.nil?

            sleep(retry_delay(retry_from, attempt))
            attempt += 1
          end
        end

        # The read/open/write timeout for this request, in seconds: `request_options[:timeout]`
        # when the caller supplied one for this call, else the client's own.
        # @param request [::Celitech::Internal::Http::BaseRequest] The HTTP request.
        # @return [Float, Integer, nil] The timeout in seconds.
        def resolve_timeout(request)
          options = request.request_options
          per_request = options&.dig(:timeout) || options&.dig('timeout')
          per_request || @timeout
        end

        # Turns a transport-level exception into this SDK's own error type, so a caller can rescue
        # a timeout or a failed connection without importing Net::HTTP's or Socket's exception
        # classes. Ruby records the original on `#cause`, so nothing is lost. No status code is
        # invented: neither failure produced a response, so there is none to report.
        # @param error [StandardError] The transport exception.
        # @return [::Celitech::Errors::ApiError] The SDK-owned error to raise.
        def wrap_transport_error(error)
          return ::Celitech::Errors::TimeoutError.new(error.message) if TIMEOUT_ERRORS.any? { |klass| error.is_a?(klass) }

          ::Celitech::Errors::ConnectionError.new(error.message)
        end

        # Whether a transport failure may be replayed. A timeout leaves the request's fate unknown —
        # the server may have applied it and only failed to answer in time — so this reuses the same
        # idempotency gate as a status-code retry rather than a looser one. A connection failure is
        # held to the same gate: a reset or a broken pipe can happen after the server accepted the
        # request, so it is no safer to replay than a timeout.
        # @param request [::Celitech::Internal::Http::BaseRequest] The HTTP request.
        # @param attempt [Integer] The current retry attempt (0-indexed).
        # @param headers [Hash] The headers already encoded for this attempt by `#send`.
        # @return [Boolean] Whether the request should be retried.
        def retry_transport_error?(request, attempt, headers)
          return false if attempt >= @max_retries

          retryable_method?(request, headers)
        end

        # Determines if a request should be retried, from the response status AND the request
        # method. The method half is not optional: a retry re-sends the request, so retrying a
        # non-idempotent write can duplicate it — a second charge, a second row — and a 503 is
        # exactly the case where the server may well have applied the first attempt before failing
        # to answer.
        # @param request [::Celitech::Internal::Http::BaseRequest] The HTTP request.
        # @param response [Net::HTTPResponse] The HTTP response.
        # @param attempt [Integer] The current retry attempt (0-indexed).
        # @param headers [Hash] The headers already encoded for this attempt by `#send`.
        # @return [Boolean] Whether the request should be retried.
        def should_retry?(request, response, attempt, headers)
          return false if attempt >= @max_retries
          return false unless retryable_method?(request, headers)

          retryable_status?(response.code.to_i)
        end

        # @param status [Integer] The response status code.
        # @return [Boolean] Whether the status code is retryable.
        def retryable_status?(status)
          return true if @retry_config[:retry_all_server_errors] && status >= 500

          @retry_config[:status_codes_to_retry].include?(status)
        end

        # Whether this request may be replayed.
        #
        # Two gates. The configured method list decides whether the method is eligible at all.
        # Eligibility alone is not enough for a non-idempotent method, though: replaying a POST or
        # a PATCH can duplicate its effect, so one is retried only when the caller supplied an
        # idempotency key for the server to deduplicate on.
        # @param request [::Celitech::Internal::Http::BaseRequest] The HTTP request.
        # @param headers [Hash] The headers already encoded for this attempt by `#send`.
        # @return [Boolean] Whether the request is safe to replay.
        def retryable_method?(request, headers)
          method = request.method.to_s.upcase
          return false unless @retry_config[:http_methods_to_retry].include?(method)
          return true if IDEMPOTENT_METHODS.include?(method)

          idempotency_key?(headers)
        end

        # Reads the headers `#send` already encoded rather than asking the request to encode them
        # again: these are the headers actually going on the wire, and re-encoding per retry
        # decision repeated work for an answer that cannot differ.
        # @param headers [Hash] The encoded HTTP request headers.
        # @return [Boolean] Whether the request carries a non-empty idempotency key header.
        def idempotency_key?(headers)
          wanted = IDEMPOTENCY_KEY_HEADERS.map(&:downcase)
          headers.any? { |name, value| wanted.include?(name.to_s.downcase) && !value.to_s.empty? }
        end

        # The default-header names a per-request header may not override.
        # @return [Array<Symbol>] The protected header names.
        def protected_header_keys
          @default_headers.keys
        end

        # The dynamic auth headers for this attempt, re-resolved per attempt so a refreshed OAuth
        # token reaches the retry. Empty when the client was built without a token provider.
        # @return [Hash] The auth headers.
        def resolve_auth_headers
          return {} unless @token_provider

          { Authorization: @token_provider.call }
        end

        # Calculates the delay before the next retry attempt using exponential backoff with jitter.
        # Respects Retry-After header if present.
        # @param response [Net::HTTPResponse, nil] The HTTP response, or nil after a transport failure.
        # @param attempt [Integer] The current retry attempt (0-indexed).
        # @return [Float] The delay in seconds before the next retry.
        def retry_delay(response, attempt)
          # Check for Retry-After header (can be seconds or HTTP date). Nil when the attempt ended
          # in a transport failure rather than a response, which has no headers to read.
          retry_after = response['Retry-After'] if response
          if retry_after
            delay = parse_retry_after(retry_after)
            return [delay, @retry_config[:max_retry_after_delay_ms] / 1000.0].min if delay&.positive?
          end

          # Exponential backoff: delay_ms * (backoff_factor ** attempt), capped, plus jitter.
          base_ms = @retry_config[:delay_ms] * (@retry_config[:backoff_factor]**attempt)
          capped_ms = [base_ms, @retry_config[:max_delay_ms]].min
          add_jitter(capped_ms) / 1000.0
        end

        # Spreads retries so concurrent clients do not resynchronise on the same backoff schedule.
        # `to_i` because `jitter_ms` is overridable per client and only an Integer range gives
        # `rand` a whole number of milliseconds to pick from — a Float bound answers with a Float,
        # and a String bound (`"50"`) has no ordering against 0 at all.
        # @param delay_ms [Numeric] The un-jittered delay in milliseconds.
        # @return [Numeric] The delay in milliseconds with jitter added.
        def add_jitter(delay_ms)
          delay_ms + rand(0..@retry_config[:jitter_ms].to_i)
        end

        # Parses the Retry-After header value.
        # @param value [String] The Retry-After header value (seconds or HTTP date).
        # @return [Float, nil] The delay in seconds, or nil if parsing fails.
        def parse_retry_after(value)
          # Try parsing as integer (seconds)
          seconds = Integer(value, exception: false)
          return seconds.to_f if seconds

          # Try parsing as HTTP date
          begin
            retry_time = Time.httpdate(value)
            delay = retry_time - Time.now
            delay.positive? ? delay : nil
          rescue ArgumentError
            nil
          end
        end

        LOCALHOST_HOSTS = %w[localhost 127.0.0.1 [::1]].freeze

        # @param request [::Celitech::Internal::Http::BaseRequest] The HTTP request.
        # @return [URI::Generic] The URL.
        def build_url(request)
          encoded_query = request.encode_query

          # If the path is already an absolute URL, use it directly
          if request.path.start_with?('http://', 'https://')
            url = request.path
            url = "#{url}?#{encode_query(encoded_query)}" if encoded_query&.any?
            parsed = URI.parse(url)
            validate_https!(parsed)
            return parsed
          end

          path = request.path.start_with?('/') ? request.path[1..] : request.path
          base = request.base_url || @base_url
          url = "#{base.chomp('/')}/#{path}"
          url = "#{url}?#{encode_query(encoded_query)}" if encoded_query&.any?
          parsed = URI.parse(url)
          validate_https!(parsed)
          parsed
        end

        # Raises if the URL uses http:// for a non-localhost host, which would
        # send authentication credentials in plaintext.
        # @param url [URI::Generic] The parsed URL.
        def validate_https!(url)
          return if url.scheme != 'http'
          return if LOCALHOST_HOSTS.include?(url.host)

          raise ArgumentError,
                "Refusing to send request to non-HTTPS URL: #{url}. " \
                'HTTP is only allowed for localhost. Use HTTPS or pass a localhost URL.'
        end

        # @param url [URI::Generic] The url to the resource.
        # @param method [String] The HTTP method to use.
        # @param headers [Hash] The headers for the request.
        # @param body [String, nil] The body for the request.
        # @return [HTTP::Request] The HTTP request.
        def build_http_request(url:, method:, headers: {}, body: nil)
          request = Net::HTTPGenericRequest.new(
            method,
            !body.nil?,
            method != 'HEAD',
            url,
          )

          request_headers = @default_headers.merge(headers)
          request_headers.each { |name, value| request[name] = value }
          request.body = body if body

          # Net::HTTP silently turns OFF its transparent gzip/deflate decoding as soon as the request
          # carries an explicit Accept-Encoding, handing back a compressed body. Re-assert it.
          request.extend(DecodeContent) if request_headers.keys.any? { |name| name.to_s.casecmp('accept-encoding').zero? }

          request
        end

        # Keeps Net::HTTP's transparent gzip/deflate response decoding enabled even when an
        # Accept-Encoding header is set explicitly on the request.
        # @api private
        module DecodeContent
          def decode_content # rubocop:disable Naming/PredicateMethod
            true
          end
        end

        # @param query [Hash, Array<String>] The query for the request. An Array carries parts
        #   that +Serializers::Params+ has already style-serialized and percent-encoded (see
        #   +BaseRequest#encode_query+), so it is joined as-is — re-encoding it would escape the
        #   `=`, `&` and style delimiters it is built from.
        # @return [String, nil] The encoded query.
        def encode_query(query)
          return query.empty? ? nil : query.join('&') if query.is_a?(::Array)

          query.to_h.empty? ? nil : URI.encode_www_form(query)
        end

        # @param url [URI::Generic] The url to connect to.
        # @return [Net::HTTP] The HTTP connection.
        def connect(url)
          is_https = (url.scheme == 'https')

          port = if url.port
                   url.port
                 elsif is_https
                   Net::HTTP.https_default_port
                 else
                   Net::HTTP.http_default_port
                 end

          http = Net::HTTP.new(url.host, port)
          http.use_ssl = is_https
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER if is_https
          # NOTE: We handle retries at the application level with HTTP status code awareness,
          # so we set max_retries to 0 to disable Net::HTTP's built-in network-level retries.
          http.max_retries = 0
          http
        end

        # @return [String]
        def inspect
          "#<#{self.class.name}:0x#{object_id.to_s(16)} @base_url=#{@base_url.inspect}>"
        end
      end
    end
  end
end
