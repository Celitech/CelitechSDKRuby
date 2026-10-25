# frozen_string_literal: true

module Celitech
  module Internal
    module Http
      # Decoding a `text/event-stream` response into the events it carries, as they arrive.
      #
      # The body is read off the socket incrementally through `RawClient#stream`, so each event
      # reaches the caller as soon as its frame is complete rather than once the whole body has been
      # buffered. Frames follow the SSE grammar: `data:` lines join with a newline, `id:` and
      # `retry:` are kept per frame, comments are skipped and a blank line dispatches.
      #
      # @api private
      module EventStream
        # One event and the SSE fields that arrived with it.
        #
        # @!attribute data
        #   @return [Object] The decoded event.
        # @!attribute id
        #   @return [String, nil] The frame's `id:`, if it sent one.
        # @!attribute event
        #   @return [String, nil] The frame's `event:` type, if it sent one.
        # @!attribute retry
        #   @return [Integer, nil] The frame's `retry:` reconnection time in milliseconds, if it sent one.
        Event = ::Struct.new(:data, :id, :event, :retry)

        # The value of a streaming method: an Enumerator of the decoded events.
        #
        # Nothing is sent until the stream is iterated, and the connection is released when
        # iteration ends, breaks or raises. A stream reads its response once: iterating it a second
        # time raises rather than re-sending the request.
        class Stream < ::Enumerator
          def initialize(&source)
            @source = source
            @started = false
            super { |yielder| start { |event| yielder << event.data } }
          end

          # The same events with their SSE metadata: each is an {Event} whose `data` is the decoded
          # event and whose `id`, `event` and `retry` are the fields its frame carried.
          #
          # @return [Enumerator<Event>]
          def with_metadata
            ::Enumerator.new { |yielder| start { |event| yielder << event } }
          end

          private

          def start(&block)
            if @started
              raise ::Celitech::Errors::ApiError,
                    'This event stream has already been read. Iterating it again would re-send the ' \
                    'request; call #to_a on the first pass if you need the events twice.'
            end
            @started = true
            @source.call(block)
          end
        end

        # The events of a streaming response, decoded by `decode_data` and read as they arrive.
        #
        # A resumable stream that drops before its terminator is reopened with the last event id
        # in `Last-Event-ID`, after the server's `retry:` delay (1 second when it sent none, at most
        # 30 seconds), for up to five consecutive attempts. `stream_reconnection_enabled` and
        # `max_stream_reconnection_attempts` change that per client, or per call in `request_options`.
        #
        # @param client [::Celitech::Internal::Http::RawClient] The HTTP client.
        # @param request [::Celitech::Internal::Http::BaseRequest] The HTTP request.
        # @param decode_data [Proc] Turns a frame's `data` into the declared event type.
        # @param terminator [String, nil] The declared end-of-stream payload, if any.
        # @param resumable [Boolean] Whether the endpoint declares the stream resumable.
        # @param event_discriminator [String, nil] The union property the frame's `event:` names.
        # @param envelope_events [Array<String>] The events whose variant models the SSE envelope.
        # @yieldparam response [Net::HTTPResponse] A non-2xx response, body already read.
        # @return [Stream] The decoded events, lazily.
        def self.decode(client, request, decode_data, terminator: nil, resumable: false,
                        event_discriminator: nil, envelope_events: [], &on_error)
          Stream.new do |emit|
            Reader.new(client, request, terminator:, resumable:, on_error:).each do |frame|
              data = discriminated_data(frame, event_discriminator, envelope_events)
              emit.call(Event.new(data: decode_data.call(data), id: frame.id, event: frame.event, retry: frame.retry))
            end
          end
        end

        # The events in an event-stream body that has already been read in full.
        #
        # @param response [Net::HTTPResponse] The HTTP response.
        # @param terminator [String, nil] The declared end-of-stream payload, if any.
        # @param event_discriminator [String, nil] The union property the frame's `event:` names.
        # @param envelope_events [Array<String>] The events whose variant models the SSE envelope.
        # @return [Enumerator] The decoded events, lazily.
        def self.decode_body(response, terminator: nil, event_discriminator: nil, envelope_events: [])
          body = response.body.to_s
          ::Enumerator.new do |yielder|
            parser = Parser.new
            parser.feed("#{body}\n\n") do |frame|
              next if frame.data.nil?
              break if !terminator.nil? && frame.data == terminator

              yielder << yield(discriminated_data(frame, event_discriminator, envelope_events))
            end
          end
        end

        # A frame's `data` with its `event:` name supplied as the union discriminant.
        #
        # A union discriminated by the SSE `event:` line never carries the discriminant in its
        # payload, so it is added to the JSON object unless the payload already has it. An event in
        # `envelope_events` is instead wrapped as `{discriminant => event, "data" => payload}`,
        # because its variant models the envelope itself. Anything else is returned unchanged.
        #
        # @return [String] The JSON document to decode.
        def self.discriminated_data(frame, event_discriminator, envelope_events)
          return frame.data if event_discriminator.nil? || frame.event.nil?

          payload = ::JSON.parse(frame.data)
          if envelope_events.include?(frame.event)
            ::JSON.generate({ event_discriminator => frame.event, 'data' => payload })
          elsif payload.is_a?(::Hash) && !payload.key?(event_discriminator)
            ::JSON.generate({ event_discriminator => frame.event }.merge(payload))
          else
            frame.data
          end
        rescue ::JSON::ParserError
          frame.data
        end
        private_class_method :discriminated_data

        # Reads a streaming response frame by frame, reopening a resumable one that drops.
        #
        # A stream has dropped when a body read fails, or when the body ends before the declared
        # terminator. With no terminator declared, the end of the body is the end of the stream.
        #
        # @api private
        class Reader
          DEFAULT_RECONNECTION_DELAY_MS = 1_000
          MAX_RECONNECTION_DELAY_MS = 30_000
          DEFAULT_MAX_RECONNECTION_ATTEMPTS = 5

          def initialize(client, request, terminator:, resumable:, on_error:)
            @client = client
            @request = request
            @terminator = terminator
            @resumable = resumable
            @on_error = on_error
            @last_event_id = nil
            @retry_ms = nil
            @attempts = 0
            @connections = 0
          end

          # @yieldparam frame [Event] Each complete frame that carries data, before decoding.
          def each(&)
            drop = nil
            loop do
              outcome = read_connection(&)
              return if outcome == :finished

              drop = outcome unless outcome == :rejected
              unless reconnect?
                raise drop if drop.is_a?(::Exception)

                return
              end
              @attempts += 1
              sleep(reconnection_delay)
            end
          end

          private

          def read_connection(&)
            consumer_error = nil
            reopening = @connections.positive?
            @connections += 1
            catch do |finished|
              @client.stream(@request, headers: resume_headers, retryable: !reopening) do |response|
                unless response.code.to_i.between?(200, 299)
                  response.read_body
                  throw finished, :rejected if reopening

                  @on_error&.call(response)
                  throw finished, :finished
                end
                read_frames(response, finished) do |frame|
                  yield frame
                rescue ::StandardError => e
                  consumer_error = e
                  raise
                end
              end
              :ended
            end
          rescue ::Celitech::Errors::ConnectionError, ::Celitech::Errors::TimeoutError => e
            raise consumer_error if consumer_error

            e
          rescue ::StandardError
            raise consumer_error if consumer_error

            raise
          end

          def read_frames(response, finished)
            parser = Parser.new
            response.read_body do |chunk|
              parser.feed(chunk) do |frame|
                @last_event_id = frame.id unless frame.id.nil?
                @retry_ms = frame.retry unless frame.retry.nil?
                next if frame.data.nil?
                throw finished, :finished if !@terminator.nil? && frame.data == @terminator

                @attempts = 0
                yield frame
              end
            end
          end

          def resume_headers
            @last_event_id.nil? ? {} : { 'Last-Event-ID' => @last_event_id }
          end

          def reconnect?
            @resumable && !@terminator.nil? && !@last_event_id.nil? &&
              reconnection_enabled? && @attempts < max_reconnection_attempts
          end

          def reconnection_enabled?
            enabled = request_option(:stream_reconnection_enabled)
            enabled = @client.stream_reconnection_enabled if enabled.nil?
            enabled != false
          end

          def max_reconnection_attempts
            attempts = request_option(:max_stream_reconnection_attempts)
            attempts = @client.max_stream_reconnection_attempts if attempts.nil?
            attempts.nil? ? DEFAULT_MAX_RECONNECTION_ATTEMPTS : attempts.to_i
          end

          def request_option(name)
            options = @request.request_options.to_h
            options.key?(name) ? options[name] : options[name.to_s]
          end

          def reconnection_delay
            delay_ms = @retry_ms.to_i.positive? ? [@retry_ms, MAX_RECONNECTION_DELAY_MS].min : DEFAULT_RECONNECTION_DELAY_MS
            delay_ms / 1000.0
          end
        end

        # Splits an event-stream body into frames, a chunk at a time. A frame is dispatched only
        # when its closing blank line arrives, so a frame cut off by the end of the body is never
        # delivered.
        #
        # @api private
        class Parser
          LINE_BREAK = /\r\n|\n|\r/
          CARRIAGE_RETURN = 13
          LINE_FEED = 10

          def initialize
            @buffer = ::String.new(encoding: ::Encoding::BINARY)
            reset
          end

          # @param chunk [String] The next bytes of the body.
          # @yieldparam frame [Event] Each frame the chunk completes; `data` is nil when it carried none.
          def feed(chunk)
            @buffer << chunk.b
            while (line = next_line)
              frame = process(line)
              yield frame if frame
            end
          end

          private

          def next_line
            index = @buffer.byteindex(LINE_BREAK)
            return nil if index.nil?

            ends_in_carriage_return = @buffer.getbyte(index) == CARRIAGE_RETURN
            return nil if ends_in_carriage_return && index == @buffer.bytesize - 1

            width = ends_in_carriage_return && @buffer.getbyte(index + 1) == LINE_FEED ? 2 : 1
            line = @buffer.byteslice(0, index)
            @buffer = @buffer.byteslice(index + width, @buffer.bytesize)
            line.force_encoding(::Encoding::UTF_8)
          end

          def process(line)
            return dispatch if line.empty?
            return nil if line.start_with?(':')

            name, colon, value = line.partition(':')
            value = value.delete_prefix(' ') unless colon.empty?
            case name
            when 'data' then @data << value
            when 'event' then @event = value
            when 'id' then @id = value unless value.include?("\0")
            when 'retry' then @retry = value.to_i if value.match?(/\A\d+\z/)
            end
            nil
          end

          # An empty payload is not dispatched: an empty string is not a document any event type can
          # load, and in practice an empty `data:` frame is a keepalive.
          def dispatch
            data = @data.join("\n")
            frame = Event.new(data: data.empty? ? nil : data, id: @id, event: @event, retry: @retry)
            reset
            frame
          end

          def reset
            @data = []
            @id = nil
            @event = nil
            @retry = nil
          end
        end
      end
    end
  end
end
