# frozen_string_literal: true

require_relative 'flow'
require_relative 'const/types'
require_relative 'octo_hash_case'
require_relative 'errors/options_validation_error'
require_relative 'errors/palp_validation_error'
require_relative 'errors/resq_definition_error'

module Decouplio
  class LogicDsl
    DEFAULT_WRAP_NAME = 'wrap'

    class << self
      attr_reader :steps, :palps

      def inherited(subclass)
        subclass.init_steps
      end

      def init_steps
        @steps = []
        @palps = {}
      end

      # option - may contain { on_success:, on_failure:, palp:, if:, unless: }
      # stp - step symbol
      def step(stp, **options)
        # raise StepNameIsReservedError
        # if stp.is_a?(Symbol)
        # raise StepMethodIsNotDefined unless self.instance_public_methods.include?(stp)
        # end
        # raise StepNameIsReserved [finish_him, on_success, on_failure, palp, if, unless]

        @steps << options.merge(type: Decouplio::Const::Types::STEP_TYPE, name: stp)
      end

      # TODO: use another name, currently it redefines Kernel#fail method
      def fail(stp, **options)
        # raise StepNameIsReservedError
        # raise FailCantBeFirstStepError, "'fail' can't be a first step, please use 'step'"

        @steps << options.merge(type: Decouplio::Const::Types::FAIL_TYPE, name: stp)
      end

      def pass(stp, **options)
        # raise StepNameIsReservedError
        @steps << options.merge(type: Decouplio::Const::Types::PASS_TYPE, name: stp)
      end

      def octo(strategy_name, **options, &block)
        hash_case = Class.new(Decouplio::OctoHashCase, &block).hash_case
        options[:hash_case] = hash_case
        @steps << options.merge(type: Decouplio::Const::Types::OCTO_TYPE, name: strategy_name)
      end

      def palp(palp_name, **options, &block)
        if block_given?
          options.empty? || raise(Decouplio::Errors::PalpValidationError)

          @palps[palp_name] = Class.new(self, &block)
        else
          # TODO: raise an error if no block given
        end
      end

      def resq(name = :resq, **options)
        unless Decouplio::Const::Types::MAIN_FLOW_TYPES.include?(@steps.last&.[](:type))
          raise Decouplio::Errors::ResqDefinitionError
        end

        @steps << {
          name: name,
          type: Decouplio::Const::Types::RESQ_TYPE,
          step_to_resq: @steps.delete(@steps.last),
          handler_hash: options
        }
      end

      def wrap(name, **options, &block)
        if block_given?
          @steps << options.merge(
            type: Decouplio::Const::Types::WRAP_TYPE,
            name: name,
            wrap_flow: Flow.call(logic: block)
          )
        else
          # TODO: raise an error
        end
      end
    end
  end
end
