require_relative 'strategy_options_validator'

module Decouplio
  class StrategyHashCase
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
        StrategyOptionsValidator.call(options: options)
      end
    end
  end
end
