# frozen_string_literal: true

module Celitech
  class Config
    attr_reader :base_url, :timeout, :enable_response_validation, :return_raw, :additional_headers, :additional_query_parameters, :retry_config

    def initialize(
      base_url: nil,
      timeout: nil,
      timeout_ms: nil,
      enable_response_validation: false,
      return_raw: false,
      additional_headers: nil,
      additional_query_parameters: nil,
      retry_config: nil
    )
      unless timeout_ms.nil?
        warn '[DEPRECATION] `timeout_ms` is deprecated; use `timeout` (seconds) instead.', uplevel: 1
        timeout = timeout_ms / 1000.0 if timeout.nil?
      end
      @base_url = base_url
      @timeout = timeout
      @enable_response_validation = enable_response_validation
      @return_raw = return_raw
      @additional_headers = additional_headers
      @additional_query_parameters = additional_query_parameters
      @retry_config = retry_config
    end

    def with(**overrides)
      base = to_h
      base.delete(:timeout) if overrides.key?(:timeout_ms) && !overrides.key?(:timeout)
      self.class.new(**base, **overrides)
    end

    def to_h
      {
        base_url: @base_url,
        timeout: @timeout,
        enable_response_validation: @enable_response_validation,
        return_raw: @return_raw,
        additional_headers: @additional_headers,
        additional_query_parameters: @additional_query_parameters,
        retry_config: @retry_config,
      }
    end
  end
end
