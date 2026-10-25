# frozen_string_literal: true

module Celitech
  module Internal
    module Http
      # Reading a JSON-lines response body as the messages it carries, as its chunks arrive.
      #
      # @api private
      module JsonStream
        METADATA_LINE = /\A(?::|(?:id|retry|event):)/

        # The messages in a JSON-lines body, each passed through the given block.
        #
        # Blank lines, comments and SSE `id`/`retry`/`event` fields are skipped.
        #
        # @param chunks [Enumerable<String>] The body's chunks, as `ByteStream.decode` yields them.
        # @param terminator [String] The declared message terminator.
        # @yieldparam message [String] One message, without its terminator.
        # @return [Enumerator] The decoded messages, lazily.
        def self.decode(chunks, terminator: "\n")
          separator = terminator.b
          ::Enumerator.new do |yielder|
            buffer = ::String.new(encoding: ::Encoding::BINARY)
            chunks.each do |chunk|
              buffer << chunk.b
              while (index = buffer.index(separator))
                message = message_text(buffer.byteslice(0, index))
                buffer = buffer.byteslice(index + separator.bytesize, buffer.bytesize)
                yielder << yield(message) unless message.nil?
              end
            end
            message = message_text(buffer)
            yielder << yield(message) unless message.nil?
          end
        end

        def self.message_text(bytes)
          line = bytes.b.chomp("\r")
          stripped = line.strip
          return nil if stripped.empty? || stripped.match?(METADATA_LINE)

          line.force_encoding(::Encoding::UTF_8)
        end
        private_class_method :message_text
      end
    end
  end
end
