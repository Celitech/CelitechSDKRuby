# frozen_string_literal: true

module Celitech
  module HTTP
    class Response
      attr_reader :status, :headers, :body, :raw_body

      def initialize(raw)
        @status   = raw.code.to_i
        @headers  = raw.each_header.to_h
        @raw_body = raw.body
        @body     = parse_body(raw.body, @headers['content-type'])
      end

      def success?
        status >= 200 && status < 300
      end

      private

      def parse_body(raw_body, content_type)
        return nil if raw_body.nil? || raw_body.empty?

        ct = content_type.to_s.split(';').first&.strip || ''
        return JSON.parse(raw_body) if ct.include?('json')
        return raw_body             if ct.start_with?('text/') || ct == 'application/xml'

        # For binary and unknown types try JSON first, fall back to raw
        JSON.parse(raw_body)
      rescue JSON::ParserError
        raw_body
      end
    end
  end
end
