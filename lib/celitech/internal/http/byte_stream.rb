# frozen_string_literal: true

module Celitech
  module Internal
    module Http
      # Reading a binary response body as the chunks it arrives in.
      #
      # An operation that declares `x-fern-streaming` over a binary body (`audio/mpeg`, `video/mp4`,
      # `application/octet-stream`) used to be generated as an ordinary method returning
      # `response.body`: the call blocked until the last byte had arrived and handed the caller one
      # String, with no way to play or write audio as it came in. This is the byte-stream
      # counterpart of `EventStream`, which does the same job for `text/event-stream`.
      #
      # @api private
      module ByteStream
        # The chunks of a binary body, lazily.
        #
        # Nothing is sent until the Enumerator is iterated, and NOTHING IS BUFFERED: each chunk is
        # handed to the caller as Net::HTTP reads it off the socket, which is the whole point — a
        # version that collected them first would be the behaviour this replaces. That laziness is
        # also why a non-2xx raises from the first iteration rather than from the call: the request
        # has not been made yet when the method returns.
        #
        # The error branch is the CALLER'S, passed as a block, because only the generated service
        # knows which error class each declared status maps to. The body is materialised before the
        # block runs, so `response.body` reads the same there as it does on the buffered path.
        #
        # Iterating a second time RAISES rather than re-requesting. An `Enumerator` built from a
        # block is re-entrant by default -- `#first` followed by `#each` runs the block twice --
        # which here would re-send the request. For a non-idempotent operation (`POST
        # /text-to-speech/.../stream`) that is a second synthesis the caller did not ask for and is
        # billed for, so a one-shot guard is the safer default. A caller who wants the chunks more
        # than once can materialise them with `#to_a` on the first pass.
        #
        # @param client [::Celitech::Internal::Http::RawClient] The HTTP client.
        # @param request [::Celitech::Internal::Http::BaseRequest] The HTTP request.
        # @yieldparam response [Net::HTTPResponse] A non-2xx response, body already read.
        # @return [Enumerator] The body's chunks, as binary Strings.
        # @raise [::Celitech::Errors::ApiError] The stream has already been iterated.
        def self.decode(client, request)
          started = false
          ::Enumerator.new do |yielder|
            if started
              raise ::Celitech::Errors::ApiError,
                    'This byte stream has already been read. Iterating it again would re-send the ' \
                    'request; call #to_a on the first pass if you need the chunks twice.'
            end
            started = true

            # The chunk the consumer was handed when its own code raised. Net::HTTP reads the body
            # inside `client.stream`'s block, so a failure in the consumer unwinds through the same
            # `rescue *TRANSPORT_ERRORS` that a genuine network failure does -- and `Errno::EPIPE`
            # from writing a chunk to a closed pipe is in that list. Recording it here is what lets
            # the caller's own exception be re-raised as itself instead of as a ConnectionError.
            consumer_error = nil
            begin
              client.stream(request) do |response|
                # An if/else rather than an early guard: `Net::HTTPResponse#read_body` raises
                # IOError when called a second time, so a guard clause would turn a block that
                # RETURNS rather than raises into `IOError: read_body called twice`. Generated error
                # branches always raise, so this is what keeps that an implementation detail.
                if response.code.to_i.between?(200, 299)
                  # An empty chunk is dropped rather than delivered: Net::HTTP can hand one back at
                  # the end of a chunked body, and a caller counting chunks or writing them to a file
                  # has no use for it.
                  response.read_body do |chunk|
                    next if chunk.nil? || chunk.empty?

                    begin
                      yielder << chunk
                    rescue ::StandardError => e
                      consumer_error = e
                      raise
                    end
                  end
                else
                  # Read here rather than leaving it to the block: `Net::HTTPResponse#body` would
                  # read it on demand, but only while this block is still on the stack. Materialising
                  # it first means an error branch can hold on to the response and read `#body` later.
                  response.read_body
                  yield response
                end
              end
            rescue ::StandardError
              raise consumer_error if consumer_error

              raise
            end
          end
        end
      end
    end
  end
end
