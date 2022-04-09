# frozen_string_literal: true

require_relative 'octo_options_validator'

module Decouplio
  class OctoHashCase
    class << self
      attr_reader :hash_case

      def inherited(subclass)
        subclass.init_hash_case
      end

      def init_hash_case
        @hash_case = {}
      end

      def on(strategy_flow, **options)
        validate_options(options)
        @hash_case[strategy_flow] = options
      end

      private

      def validate_options(options)
        OctoOptionsValidator.call(options: options)
      end
    end
  end
end
