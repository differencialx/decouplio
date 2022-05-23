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
require_relative 'errors/octo_block_is_not_defined_error'

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
        raise Decouplio::Errors::FailCanNotBeTheFirstStepError if @steps.empty?

        @steps << options.merge(type: Decouplio::Const::Types::FAIL_TYPE, name: stp)
      end

      def pass(stp, **options)
        @steps << options.merge(type: Decouplio::Const::Types::PASS_TYPE, name: stp)
      end

      def octo(octo_name, **options, &block)
        raise Decouplio::Errors::OctoBlockIsNotDefinedError unless block_given?

        hash_case = Class.new(Decouplio::OctoHashCase, &block).hash_case

        raise Decouplio::Errors::OctoBlockIsNotDefinedError if hash_case.empty?

        options[:hash_case] = hash_case
        @steps << options.merge(type: Decouplio::Const::Types::OCTO_TYPE, name: octo_name)
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
          wrap_flow: block
        )
      end

      def doby(doby_class, **options)
        @steps << {
          type: Decouplio::Const::Types::DOBY_TYPE,
          name: doby_class.name.to_sym,
          doby_class: doby_class,
          doby_options: options
        }
      end
    end
  end
end
