# frozen_string_literal: true

require_relative 'flow'
require_relative 'const/types'
require_relative 'const/doby_aide_options'
require_relative 'const/step_options'
require_relative 'octo_hash_case'
require_relative 'errors/options_validation_error'
require_relative 'errors/palp_validation_error'
require_relative 'errors/resq_definition_error'
require_relative 'errors/wrap_block_is_not_defined_error'
require_relative 'errors/palp_block_is_not_defined_error'
require_relative 'errors/fail_can_not_be_first_step_error'
require_relative 'errors/aide_can_not_be_first_step_error'
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
        if stp.is_a?(Class) && !(stp < Decouplio::Action)
          step_options = {}

          options.each_key do |key|
            step_options[key] = options.delete(key) if Decouplio::Const::StepOptions::ALLOWED.include?(key)
          end

          @steps << {
            type: Decouplio::Const::Types::STEP_TYPE,
            name: stp,
            _args: options,
            **step_options
          }
        else
          @steps << options.merge(type: Decouplio::Const::Types::STEP_TYPE, name: stp)
        end
      end

      def fail(stp, **options)
        raise Decouplio::Errors::FailCanNotBeFirstStepError if @steps.empty?

        if stp.is_a?(Class) && !(stp < Decouplio::Action)
          step_options = {}
          options.each_key do |key|
            step_options[key] = options.delete(key) if Decouplio::Const::StepOptions::ALLOWED.include?(key)
          end

          @steps << {
            type: Decouplio::Const::Types::FAIL_TYPE,
            name: stp,
            _args: options,
            **step_options
          }
        else
          @steps << options.merge(type: Decouplio::Const::Types::FAIL_TYPE, name: stp)
        end
      end

      def pass(stp, **options)
        if stp.is_a?(Class) && !(stp < Decouplio::Action)
          step_options = {}

          options.each_key do |key|
            step_options[key] = options.delete(key) if Decouplio::Const::StepOptions::ALLOWED.include?(key)
          end

          @steps << {
            type: Decouplio::Const::Types::PASS_TYPE,
            name: stp,
            _args: options,
            **step_options
          }
        else
          @steps << options.merge(type: Decouplio::Const::Types::PASS_TYPE, name: stp)
        end
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
        warn(
          'DEPRECATION WARNING: "doby" step type will be deprecated at alpha7 version. Use "step" or "pass" instead.'
        )
        step_options = {}
        options.each_key do |key|
          step_options[key] = options.delete(key) if Decouplio::Const::DobyAideOptions::ALLOWED.include?(key)
        end
        doby_options = options

        @steps << {
          type: Decouplio::Const::Types::DOBY_TYPE,
          name: doby_class.name.to_sym,
          doby_class: doby_class,
          doby_options: doby_options,
          **step_options
        }
      end

      def aide(aide_class, **options)
        warn('DEPRECATION WARNING: "aide" step type will be deprecated at alpha7 version. Use "fail" instead.')
        raise Decouplio::Errors::AideCanNotBeFirstStepError if @steps.empty?

        step_options = {}
        options.each_key do |key|
          step_options[key] = options.delete(key) if Decouplio::Const::DobyAideOptions::ALLOWED.include?(key)
        end
        aide_options = options

        @steps << {
          type: Decouplio::Const::Types::AIDE_TYPE,
          name: aide_class.name.to_sym,
          aide_class: aide_class,
          aide_options: aide_options,
          **step_options
        }
      end
    end
  end
end
