# frozen_string_literal: true

require 'json'
require 'net/http'
require 'time'
require 'uri'

module Celitech
  module HTTP
    class Connection
      attr_accessor :default_headers
      attr_reader :base_url, :timeout, :retry_config

      def base_url=(new_url)
        new_uri = URI.parse(new_url.chomp('/'))
        @mutex.synchronize do
          # A caller-supplied client owns its own connection target; never tear it down
          # or repoint it. Warn on a host/port change so requests aren't silently sent
          # to the injected client's original host with the new path.
          if @custom_http
            if new_uri.host != @http.address || new_uri.port != @http.port
              warn '[Celitech] base_url host/port change ignored: a custom ' \
                   'http_client is in use and keeps its own connection target.'
            end
            @base_url = new_url
            @uri = new_uri
            next
          end

          @base_url = new_url
          @uri = new_uri
          begin
            @http&.finish
          rescue StandardError
            nil
          end
          @http = Net::HTTP.new(@uri.host, @uri.port)
          @http.use_ssl = @uri.scheme == 'https'
          if @timeout
            @http.open_timeout = @timeout
            @http.read_timeout = @timeout
          end
          # Don't call @http.start here — the execute/reconnect path starts it
          # lazily on the first request, which avoids eager DNS lookups when
          # switching environments before a request is actually made.
        end
      end

      def initialize(base_url, default_headers = {}, timeout: nil, refresh_manager: nil, retry_config: nil, http_client: nil)
        @base_url        = base_url
        @timeout         = timeout
        @retry_config    = retry_config
        @uri             = URI.parse(base_url.chomp('/'))
        # A caller-supplied http_client is used as-is: the SDK never reconfigures its
        # transport (TLS, timeouts, proxy) — the caller owns those settings.
        @custom_http     = !http_client.nil?
        @http            = http_client || Net::HTTP.new(@uri.host, @uri.port)
        @default_headers = { 'User-Agent' => 'postman-codegen/2.6.0 celitech/2.0.6 (ruby)' }.merge(default_headers)
        @refresh_manager = refresh_manager
        @mutex           = Mutex.new
        @hook            = Hooks.new
        unless @custom_http
          @http.use_ssl = @uri.scheme == 'https'
          if timeout
            @http.open_timeout = timeout
            @http.read_timeout = timeout
          end
        end
        @http.start unless @http.started?
      end

      def get(path, params = {}, headers = {})
        execute(Net::HTTP::Get.new(build_path(path, params), normalize_headers(@default_headers.merge(headers))))
      end

      def post(path, body = nil, content_type: 'application/json', headers: {})
        req = Net::HTTP::Post.new(base_path(path), normalize_headers(@default_headers.merge(headers)))
        set_body(req, body, content_type)
        execute(req)
      end

      def put(path, body = nil, content_type: 'application/json', headers: {})
        req = Net::HTTP::Put.new(base_path(path), normalize_headers(@default_headers.merge(headers)))
        set_body(req, body, content_type)
        execute(req)
      end

      def patch(path, body = nil, content_type: 'application/json', headers: {})
        req = Net::HTTP::Patch.new(base_path(path), normalize_headers(@default_headers.merge(headers)))
        set_body(req, body, content_type)
        execute(req)
      end

      def delete(path, headers = {})
        execute(Net::HTTP::Delete.new(base_path(path), normalize_headers(@default_headers.merge(headers))))
      end

      def head(path, params = {}, headers = {})
        execute(Net::HTTP::Head.new(build_path(path, params), normalize_headers(@default_headers.merge(headers))))
      end

      def options(path, params = {}, headers = {})
        execute(Net::HTTP::Options.new(build_path(path, params), normalize_headers(@default_headers.merge(headers))))
      end

      def stream_get(path, params = {}, headers = {})
        stream_execute(Net::HTTP::Get.new(build_path(path, params), normalize_headers(@default_headers.merge(headers))))
      end

      def stream_post(path, body = nil, content_type: 'application/json', headers: {})
        req = Net::HTTP::Post.new(base_path(path), normalize_headers(@default_headers.merge(headers)))
        set_body(req, body, content_type)
        stream_execute(req)
      end

      private

      # Connection is opened once in initialize and reused across requests.
      # If the server closes the socket (idle timeout, restart, etc.) we
      # transparently reconnect once before giving up.
      def execute(req)
        attempts = 0
        params = {}
        @hook.before_request(req, params)
        begin
          attempts += 1
          raw = @mutex.synchronize do
            @http.request(req)
          rescue IOError, Errno::ECONNRESET, Errno::EPIPE
            reconnect
            @http.request(req)
          end
          response = Response.new(raw)
          raise APIError.new(response.status, response.body, response.headers) unless response.success?
          @hook.after_response(req, response, params)
          response
        rescue APIError => e
          if attempts < (@retry_config&.fetch(:attempts, nil) || 3) && %w[GET POST PUT DELETE PATCH HEAD OPTIONS].include?(req.method.upcase) && (e.status >= 500 || e.status == 408 || e.status == 429)
            sleep(retry_after_delay(e) || retry_delay(attempts))
            retry
          end
          @hook.on_error(e, req, params)
          raise
        end
      rescue Net::ReadTimeout, Net::OpenTimeout => e
        raise TimeoutError, e.message
      end

      def stream_execute(req)
        Enumerator.new do |yielder|
          opts = { use_ssl: @uri.scheme == 'https' }
          if @timeout
            opts[:open_timeout] = @timeout
            opts[:read_timeout] = @timeout
          end
          params = {}
          @hook.before_request(req, params)
          begin
            Net::HTTP.start(@uri.host, @uri.port, **opts) do |http|
              http.request(req) do |raw|
                status = raw.code.to_i
                unless status >= 200 && status < 300
                  error = APIError.new(status, raw.read_body, raw.each_header.to_h)
                  @hook.on_error(error, req, params)
                  raise error
                end

                content_type = raw['content-type'].to_s.split(';').first&.strip || ''
                is_sse = content_type == 'text/event-stream'
                buffer = +''

                raw.read_body do |chunk|
                  buffer << chunk
                  while (idx = buffer.index("\n"))
                    line = buffer.slice!(0, idx + 1).chomp
                    if is_sse
                      next unless line.start_with?('data:')

                      data = line[5..].delete_prefix(' ')
                      next if data == '[DONE]'

                      yielder << JSON.parse(data)
                    else
                      yielder << JSON.parse(line) unless line.empty?
                    end
                  end
                end

                unless buffer.empty?
                  if is_sse
                    if buffer.start_with?('data:')
                      data = buffer[5..].delete_prefix(' ')
                      yielder << JSON.parse(data) unless data == '[DONE]'
                    end
                  else
                    yielder << JSON.parse(buffer)
                  end
                end
              end
            end
          rescue Net::ReadTimeout, Net::OpenTimeout => e
            raise TimeoutError, e.message
          end
        end
      end

      # Returns seconds to wait before the next retry attempt.
      # Uses exponential backoff capped at maxDelay, plus random jitter.
      def retry_delay(attempt)
        base_ms   = 150 * (2**(attempt - 1))
        capped_ms = [base_ms, 5000].min
        jitter_ms = rand(0..50)
        (capped_ms + jitter_ms) / 1000.0
      end

      # Honors a server-directed retry delay from rate-limit response headers:
      # Retry-After (delta-seconds or HTTP-date), or X-RateLimit-Reset (epoch seconds)
      # when Retry-After is absent. Returns the delay in seconds clamped to
      # [0, maxRetryAfterDelay], or nil when no usable header is present so the caller
      # falls back to the computed exponential backoff.
      def retry_after_delay(error)
        headers = error.respond_to?(:headers) ? error.headers : nil
        return nil unless headers.is_a?(Hash)

        max_s = 60_000 / 1000.0
        return nil unless max_s.positive?

        # Normalize keys to lowercase hyphenated strings so lookups are robust to
        # header casing and symbol keys regardless of how the error was constructed.
        normalized = headers.each_with_object({}) do |(k, v), acc|
          acc[k.to_s.downcase.tr('_', '-')] = v
        end

        # retry-after-ms (milliseconds) is a non-standard but finer-grained hint some
        # APIs send (e.g. OpenAI); it takes precedence over the whole-second Retry-After.
        ms = normalized['retry-after-ms'].to_s.strip
        return (ms.to_f / 1000.0).clamp(0.0, max_s) if ms.match?(/\A\d+(\.\d+)?\z/)

        seconds = parse_retry_after(normalized['retry-after'])
        return seconds.clamp(0.0, max_s) unless seconds.nil?

        # X-RateLimit-Reset is interpreted as epoch seconds (the common convention).
        reset = normalized['x-ratelimit-reset']
        unless reset.nil? || reset.to_s.strip.empty?
          seconds = reset.to_f - Time.now.to_f
          return seconds.clamp(0.0, max_s) if seconds.positive?
        end
        nil
      end

      # Parses a Retry-After header value: an integer/float number of seconds, or an
      # HTTP-date. Returns the delay in seconds (Float) or nil if unparseable.
      def parse_retry_after(value)
        return nil if value.nil?

        str = value.to_s.strip
        return nil if str.empty?
        return str.to_f if str.match?(/\A\d+(\.\d+)?\z/)

        begin
          Time.httpdate(str).to_f - Time.now.to_f
        rescue ArgumentError
          nil
        end
      end

      # Collapses array header values into a comma-separated string.
      # Matches OpenAPI style=simple, explode=false (the default for header parameters).
      def normalize_headers(hdrs)
        return hdrs unless hdrs.any? { |_, v| v.is_a?(Array) }

        hdrs.transform_values { |v| v.is_a?(Array) ? v.join(',') : v }
      end

      def reconnect
        begin
          @http.finish
        rescue StandardError
          nil
        end
        @http.start
      end

      def set_body(req, body, content_type)
        return unless body

        case content_type
        when /json/
          req.body = Serializers::Json.serialize(body).to_json
          req['Content-Type'] = content_type
        when 'application/xml'
          req.body = Serializers::Xml.serialize(body)
          req['Content-Type'] = 'application/xml'
        when 'application/x-www-form-urlencoded'
          req.body = Serializers::Form.to_urlencoded(body)
          req['Content-Type'] = 'application/x-www-form-urlencoded'
        when 'multipart/form-data'
          Serializers::Form.set_multipart(req, body)
        when %r{^text/}
          req.body = body.to_s
          req['Content-Type'] = content_type
        else
          # Binary and other raw types
          req.body = body.respond_to?(:read) ? body.read : body.to_s
          req['Content-Type'] = content_type
        end
      end

      def base_path(path)
        "#{@uri.path.chomp('/')}#{path}"
      end

      def build_path(path, params)
        return base_path(path) if params.nil? || params.empty?

        query = params.is_a?(Hash) ? URI.encode_www_form(params) : params
        "#{base_path(path)}?#{query}"
      end
    end
  end
end
