# frozen_string_literal: true

require_relative 'flow'
require_relative 'const/const'
require_relative 'octo_hash_case'
require_relative 'errors/options_validation_error'

module Decouplio
  class LogicDsl
    DEFAULT_WRAP_NAME = 'wrap'

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

        @steps << options.merge(type: Decouplio::Const::STEP_TYPE, name: stp)
      end

      # TODO: use another name, currently it redefines Kernel#fail method
      def fail(stp, **options)
        # raise StepNameIsReservedError
        # raise FailCantBeFirstStepError, "'fail' can't be a first step, please use 'step'"

        @steps << options.merge(type: Decouplio::Const::FAIL_TYPE, name: stp)
      end

      def pass(stp, **options)
        # raise StepNameIsReservedError
        @steps << options.merge(type: Decouplio::Const::PASS_TYPE, name: stp)
      end

      def strg(strategy_name, **options, &block)
        hash_case = Class.new(Decouplio::OctoHashCase, &block).hash_case
        options[:hash_case] = hash_case
        @steps << options.merge(type: Decouplio::Const::OCTO_TYPE, name: strategy_name)
      end

      def squad(squad_name, **options, &block)
        if block_given?
          unless options.empty?
            raise Decouplio::Errors::OptionsValidationError,
                  "\033[1;33m Squad does not allow any options \033[0m"
          end

          @squads[squad_name] = Class.new(self, &block)
        else
          # TODO: raise an error if no block given
        end
      end

      def resq(name=:resq, **options)
        unless Decouplio::Const::MAIN_FLOW_TYPES.include?(@steps.last&.[](:type))
          raise Decouplio::Errors::OptionsValidationError,
                <<~ERROR
                  \033[1;33m
                  "resq" should be defined only after:
                  #{Decouplio::Const::MAIN_FLOW_TYPES.join("\n")}
                  \033[0m
                ERROR

        end

        @steps << {
          name: name,
          type: Decouplio::Const::RESQ_TYPE,
          step_to_resq: @steps.delete(@steps.last),
          handler_hash: options
        }
      end

      def wrap(name, **options, &block)
        if block_given?
          @steps << options.merge(
            type: Decouplio::Const::WRAP_TYPE,
            name: name,
            wrap_flow: Flow.call(logic: block, action_class: self)
          )
        else
          # TODO: raise an error
        end
      end
    end
  end
end
