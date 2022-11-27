# frozen_string_literal: true

module Decouplio
  class OctoOptionsValidator
    def self.call(options:)
      new(options: options).call
    end

    def initialize(options:)
      @options = options
    end

    def call
      validate_options unless @options.empty?
    end

    private

    def validate_options
      has_invalid_options = @options.keys.any? { |key| NOT_ALLOWED_OPTIONS.include?(key) }

      return unless has_invalid_options

      raise_validation_error
    end

    def raise_validation_error
      raise Decouplio::Errors::OptionsValidationError.new(
        errored_option: @options
      )
    end

    NOT_ALLOWED_OPTIONS = %i[finish_him if unless].freeze
  end
end
