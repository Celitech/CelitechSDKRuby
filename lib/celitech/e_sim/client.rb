# frozen_string_literal: true

require 'uri'

module Celitech
  module ESim
    class Client
      def initialize(client:)
        @client = client
      end

      # Get eSIM
      def get_esim(request_options: {}, **params)
        params = ::Celitech::Internal::Types::Utils.normalize_keys(params)
        query_params = {}
        query_params['iccid'] = params[:iccid] if params.key?(:iccid)
        request = ::Celitech::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: 'GET',
          path: 'esim',
          query: query_params,
          request_options: request_options,
        )
        response = @client.send(request)
        code = response.code.to_i
        if code.between?(200, 299)
          result = ::Celitech::Internal::Http::ResponseBody.decode(response) { |body| ::Celitech::ESim::Types::GetEsimResponse.load(body) }
          result.validate! if result.respond_to?(:validate!)
          result
        else
          error_class = ::Celitech::Errors::ResponseError.subclass_for_code(code)
          error_body = ::Celitech::Errors::ResponseError.load_body(response.body, { 400 => ::Celitech::Types::ErrorResponse, 401 => ::Celitech::Types::ErrorResponse, 409 => ::Celitech::Types::ErrorResponse, 422 => ::Celitech::Types::ErrorResponse, 503 => ::Celitech::Types::ErrorResponse }[code])
          raise error_class.new(response.body, code: code, body: error_body)
        end
      end

      # Get eSIM Device
      def get_esim_device(request_options: {}, **params)
        params = ::Celitech::Internal::Types::Utils.normalize_keys(params)
        request = ::Celitech::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: 'GET',
          path: "esim/#{URI.encode_uri_component(params[:iccid].to_s)}/device",
          request_options: request_options,
        )
        response = @client.send(request)
        code = response.code.to_i
        if code.between?(200, 299)
          result = ::Celitech::Internal::Http::ResponseBody.decode(response) { |body| ::Celitech::ESim::Types::GetEsimDeviceResponse.load(body) }
          result.validate! if result.respond_to?(:validate!)
          result
        else
          error_class = ::Celitech::Errors::ResponseError.subclass_for_code(code)
          error_body = ::Celitech::Errors::ResponseError.load_body(response.body, { 400 => ::Celitech::Types::ErrorResponse, 401 => ::Celitech::Types::ErrorResponse, 409 => ::Celitech::Types::ErrorResponse, 422 => ::Celitech::Types::ErrorResponse, 503 => ::Celitech::Types::ErrorResponse }[code])
          raise error_class.new(response.body, code: code, body: error_body)
        end
      end

      # Get eSIM History
      def get_esim_history(request_options: {}, **params)
        params = ::Celitech::Internal::Types::Utils.normalize_keys(params)
        request = ::Celitech::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: 'GET',
          path: "esim/#{URI.encode_uri_component(params[:iccid].to_s)}/history",
          request_options: request_options,
        )
        response = @client.send(request)
        code = response.code.to_i
        if code.between?(200, 299)
          result = ::Celitech::Internal::Http::ResponseBody.decode(response) { |body| ::Celitech::ESim::Types::GetEsimHistoryResponse.load(body) }
          result.validate! if result.respond_to?(:validate!)
          result
        else
          error_class = ::Celitech::Errors::ResponseError.subclass_for_code(code)
          error_body = ::Celitech::Errors::ResponseError.load_body(response.body, { 400 => ::Celitech::Types::ErrorResponse, 401 => ::Celitech::Types::ErrorResponse, 409 => ::Celitech::Types::ErrorResponse, 422 => ::Celitech::Types::ErrorResponse, 503 => ::Celitech::Types::ErrorResponse }[code])
          raise error_class.new(response.body, code: code, body: error_body)
        end
      end

      # Suspends an eSIM to prevent abuse. All of the eSIM's packages are terminated and its connectivity is switched off. The eSIM is not refunded: the charge stays.
      def suspend_esim(request_options: {}, **params)
        params = ::Celitech::Internal::Types::Utils.normalize_keys(params)
        headers = {}
        headers['Idempotency-Key'] = ::Celitech::Internal::Types::Utils.simple_param(params[:idempotency_key]) if params.key?(:idempotency_key)
        request = ::Celitech::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: 'POST',
          path: "esim/#{URI.encode_uri_component(params[:iccid].to_s)}/suspend",
          headers: headers,
          request_options: request_options,
        )
        response = @client.send(request)
        code = response.code.to_i
        if code.between?(200, 299)
          result = ::Celitech::Internal::Http::ResponseBody.decode(response) { |body| ::Celitech::ESim::Types::SuspendEsimResponse.load(body) }
          result.validate! if result.respond_to?(:validate!)
          result
        else
          error_class = ::Celitech::Errors::ResponseError.subclass_for_code(code)
          error_body = ::Celitech::Errors::ResponseError.load_body(response.body, { 400 => ::Celitech::Types::ErrorResponse, 401 => ::Celitech::Types::ErrorResponse, 409 => ::Celitech::Types::ErrorResponse, 422 => ::Celitech::Types::ErrorResponse, 503 => ::Celitech::Types::ErrorResponse }[code])
          raise error_class.new(response.body, code: code, body: error_body)
        end
      end
    end
  end
end
