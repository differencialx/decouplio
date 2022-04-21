# frozen_string_literal: true

require_relative 'errors/options_validation_error'

module Decouplio
  class OctoOptionsValidator
    def self.call(options:)
      new(options: options).call
    end

    def initialize(options:)
      @options = options
    end

    def call
      validate_option_keys
      validate_option_count
    end

    private

    def validate_option_keys
      extra_options = (@options.keys - ON_ALLOWED_OPTIONS)
      return if extra_options.size.zero?

      raise_validation_error(
        compose_message(
          STRATEGY_ON_ERROR_MESSAGE,
          YELLOW,
          extra_options,
          EXTRA_OPTIONS_NOT_ALLOWED % extra_options,
          ON_ALLOWED_OPTIONS,
          STRATEGY_MANUAL_URL,
          NO_COLOR
        )
      )
    end

    def validate_option_count
      return if @options.keys.size == 1

      raise_validation_error(
        compose_message(
          STRATEGY_ON_ERROR_MESSAGE,
          YELLOW,
          @options,
          ONLY_ONE_OPTION_PER_TIME_IS_ALLOWED,
          ON_ALLOWED_OPTIONS,
          STRATEGY_MANUAL_URL,
          NO_COLOR
        )
      )
    end

    def raise_validation_error(message)
      raise Decouplio::Errors::OptionsValidationError, message
    end

    def compose_message(message, *interpolation_params)
      message % interpolation_params
    end

    ALLOWED_OPTIONS = %i[palp step].freeze
    YELLOW = "\033[1;33m"
    NO_COLOR = "\033[0m"
    STRATEGY_ON_ERROR_MESSAGE = <<~ERROR_MESSAGE
      %s
      Next options are not allowed for "on":
      %s

      Details:
      %s

      Allowed options are:
      %s

      Please read the manual about allowed options here:
      %s
      %s
    ERROR_MESSAGE
    EXTRA_OPTIONS_NOT_ALLOWED = '%s is not allowed for "on"'
    ONLY_ONE_OPTION_PER_TIME_IS_ALLOWED = 'Only one option is allowed for "on".'
    ON_ALLOWED_OPTIONS = %i[
      step
      palp
    ].freeze
    STRATEGY_MANUAL_URL = 'https://stub.strategy.manual.url'
  end
end
