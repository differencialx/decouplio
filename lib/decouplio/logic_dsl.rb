require_relative 'options_composer'
require_relative 'strategy_hash_case'

module Decouplio
  class LogicDsl
    class << self
      attr_reader :steps, :squads

      def inherited(subclass)
        subclass.init_steps
      end

      def init_steps
        @steps = []
        @squads = {}
      end

      # option - may contain { on_success:, on_failure:, squad:, if:, unless: }
      # stp - step symbol
      def step(stp, **options)
        # raise StepNameIsReservedError
        # if stp.is_a?(Symbol)
          # raise StepMethodIsNotDefined unless self.instance_public_methods.include?(stp)
        # end
        # raise StepNameIsReserved [finish_him, on_success, on_failure, squad, if, unless]

        # composed_options = OptionsComposer.call(name: stp, options: options, type: Decouplio::Step::STEP_TYPE)
        # @steps << composed_options[:options]
        @steps << options.merge(type: Decouplio::Step::STEP_TYPE, name: stp)
      end

      # TODO: use another name, currently it redefines Kernel#fail method
      def fail(stp, **options)
        # raise StepNameIsReservedError
        # raise FailCantBeFirstStepError, "'fail' can't be a first step, please use 'step'"

        # composed_options = OptionsComposer.call(name: stp, options: options, type: Decouplio::Step::FAIL_TYPE)
        # @steps << composed_options[:options]
        @steps << options.merge(type: Decouplio::Step::FAIL_TYPE, name: stp)
      end

      def pass(stp, **options)
        # raise StepNameIsReservedError
        # composed_options = OptionsComposer.call(name: stp, options: options, type: Decouplio::Step::PASS_TYPE)
        # @steps << composed_options[:options]
        @steps << options.merge(type: Decouplio::Step::PASS_TYPE, name: stp)
      end

      def strg(strategy_name, **options, &block)
        hash_case = Class.new(Decouplio::StrategyHashCase, &block).hash_case
        options[:hash_case] = hash_case
        # composed_options = OptionsComposer.call(name: strategy_name, options: options, type: Decouplio::Step::STRATEGY_TYPE)
        # @steps << composed_options[:options]
        @steps << options.merge(type: Decouplio::Step::STRATEGY_TYPE, name: strategy_name)
      end

      def squad(squad_name, &block)
        if block_given?
          # squad_wrapped_by_logic = Proc.new do
          #   logic(&block)
          # end

          @squads[squad_name] = Step.new(
            steps: Class.new(self, &block),
            type: Decouplio::Step::SQUAD_TYPE
          )
        else
          # TODO: raise an error
        end
      end
    end
  end
end
