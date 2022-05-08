# frozen_string_literal: true

require_relative 'flow'
require_relative 'const/types'
require_relative 'octo_hash_case'
require_relative 'errors/options_validation_error'
require_relative 'errors/palp_validation_error'
require_relative 'errors/resq_definition_error'
require_relative 'errors/wrap_block_is_not_defined_error'
require_relative 'errors/palp_block_is_not_defined_error'
require_relative 'errors/fail_is_first_step_error'

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

      def step(stp, **options)
        @steps << options.merge(type: Decouplio::Const::Types::STEP_TYPE, name: stp)
      end

      def fail(stp, **options)
        raise Decouplio::Errors::FailBlockIsNotDefinedError if @steps.empty?

        @steps << options.merge(type: Decouplio::Const::Types::FAIL_TYPE, name: stp)
      end

      def pass(stp, **options)
        @steps << options.merge(type: Decouplio::Const::Types::PASS_TYPE, name: stp)
      end

      def octo(strategy_name, **options, &block)
        hash_case = Class.new(Decouplio::OctoHashCase, &block).hash_case
        options[:hash_case] = hash_case
        @steps << options.merge(type: Decouplio::Const::Types::OCTO_TYPE, name: strategy_name)
      end

      def palp(palp_name, **options, &block)
        raise Decouplio::Errors::PalpBlockIsNotDefinedError unless block_given?

        options.empty? || raise(Decouplio::Errors::PalpValidationError)

        @palps[palp_name] = Class.new(self, &block)
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

      def wrap(name = nil, **options, &block)
        raise Decouplio::Errors::WrapBlockIsNotDefinedError unless block_given?

        @steps << options.merge(
          type: Decouplio::Const::Types::WRAP_TYPE,
          name: name,
          wrap_flow: Flow.call(logic: block)
        )
      end
    end
  end
end
