# frozen_string_literal: true

module Decouplio
  class LogicDsl
    class << self
      attr_reader :steps

      def inherited(subclass)
        subclass.init_steps
      end

      def init_steps
        @steps = []
      end

      def step(stp, **options)
        if_condition = options.delete(:if)
        unless_condition = options.delete(:unless)

        if if_condition && unless_condition
          raise Decouplio::Errors::StepControversialKeysError.new(
            errored_option: { if: if_condition, unless: unless_condition },
            details: %i[if unless]
          )
        end

        if if_condition
          @steps << Decouplio::Steps::IfConditionPass.new(
            if_condition
          )
        end
        if unless_condition
          @steps << Decouplio::Steps::UnlessConditionPass.new(
            unless_condition
          )
        end

        if stp.is_a?(Class)
          if stp < Decouplio::Action
            @steps << Decouplio::Steps::InnerActionStep.new(
              stp.name.to_sym,
              stp,
              options.delete(:on_success),
              options.delete(:on_failure),
              options.delete(:on_error),
              options.delete(:finish_him)
            )
          elsif stp.respond_to?(:call)
            @steps << Decouplio::Steps::ServiceAsStep.new(
              stp.name.to_sym,
              stp,
              options.delete(:on_success),
              options.delete(:on_failure),
              options.delete(:on_error),
              options.delete(:finish_him),
              options
            )
          else
            raise Decouplio::Errors::ActionClassError.new(
              step_type: :step,
              errored_option: "step #{stp}"
            )
          end
        else
          @steps << Decouplio::Steps::Step.new(
            stp,
            options.delete(:on_success),
            options.delete(:on_failure),
            options.delete(:on_error),
            options.delete(:finish_him)
          )
        end
      end

      def fail(stp, **options)
        raise Decouplio::Errors::FailCanNotBeFirstStepError if @steps.empty?

        if_condition = options.delete(:if)
        unless_condition = options.delete(:unless)

        if if_condition && unless_condition
          raise Decouplio::Errors::FailControversialKeysError.new(
            errored_option: { if: if_condition, unless: unless_condition },
            details: %i[if unless]
          )
        end

        if if_condition
          @steps << Decouplio::Steps::IfConditionFail.new(
            if_condition
          )
        end
        if unless_condition
          @steps << Decouplio::Steps::UnlessConditionFail.new(
            unless_condition
          )
        end

        if stp.is_a?(Class)
          if stp < Decouplio::Action
            @steps << Decouplio::Steps::InnerActionFail.new(
              stp.name.to_sym,
              stp,
              options.delete(:on_success),
              options.delete(:on_failure),
              options.delete(:on_error),
              options.delete(:finish_him)
            )
          elsif stp.respond_to?(:call)
            @steps << Decouplio::Steps::ServiceAsFail.new(
              stp.name.to_sym,
              stp,
              options.delete(:on_success),
              options.delete(:on_failure),
              options.delete(:on_error),
              options.delete(:finish_him),
              options
            )
          else
            raise Decouplio::Errors::ActionClassError.new(
              step_type: :fail,
              errored_option: "fail #{stp}"
            )
          end
        else
          @steps << Decouplio::Steps::Fail.new(
            stp,
            options.delete(:on_success),
            options.delete(:on_failure),
            options.delete(:on_error),
            options.delete(:finish_him)
          )
        end
      end

      def pass(stp, **options)
        on_success = options.delete(:on_success)
        on_failure = options.delete(:on_failure)

        if on_success
          raise Decouplio::Errors::ExtraKeyForPassError.new(
            errored_option: { on_success: on_success },
            details: :on_success
          )
        elsif on_failure
          raise Decouplio::Errors::ExtraKeyForPassError.new(
            errored_option: { on_failure: on_failure },
            details: :on_failure
          )
        end

        if_condition = options.delete(:if)
        unless_condition = options.delete(:unless)

        if if_condition && unless_condition
          raise Decouplio::Errors::PassControversialKeysError.new(
            errored_option: { if: if_condition, unless: unless_condition },
            details: %i[if unless]
          )
        end

        if if_condition
          @steps << Decouplio::Steps::IfConditionPass.new(
            if_condition
          )
        end
        if unless_condition
          @steps << Decouplio::Steps::UnlessConditionPass.new(
            unless_condition
          )
        end

        if stp.is_a?(Class)
          if stp < Decouplio::Action
            @steps << Decouplio::Steps::InnerActionPass.new(
              stp.name.to_sym,
              stp,
              nil,
              nil,
              options.delete(:on_error),
              options.delete(:finish_him)
            )
          elsif stp.respond_to?(:call)
            @steps << Decouplio::Steps::ServiceAsPass.new(
              stp.name.to_sym,
              stp,
              nil,
              nil,
              options.delete(:on_error),
              options.delete(:finish_him),
              options
            )
          else
            raise Decouplio::Errors::ActionClassError.new(
              step_type: :pass,
              errored_option: "pass #{stp}"
            )
          end
        else
          @steps << Decouplio::Steps::Pass.new(
            stp,
            nil,
            nil,
            options.delete(:on_error),
            options.delete(:finish_him)
          )
        end
      end

      def octo(octo_name, **options, &block)
        raise Decouplio::Errors::OctoBlockIsNotDefinedError unless block_given?

        hash_case = Class.new(Decouplio::OctoHashCase, &block).hash_case

        raise Decouplio::Errors::OctoBlockIsNotDefinedError if hash_case.empty?

        if_condition = options.delete(:if)
        unless_condition = options.delete(:unless)

        if if_condition && unless_condition
          raise Decouplio::Errors::OctoControversialKeysError.new(
            errored_option: { if: if_condition, unless: unless_condition },
            details: %i[if unless]
          )
        end

        if if_condition
          @steps << Decouplio::Steps::IfConditionPass.new(
            if_condition
          )
        end
        if unless_condition
          @steps << Decouplio::Steps::UnlessConditionPass.new(
            unless_condition
          )
        end

        by_method = options.delete(:method)
        by_key = options.delete(:ctx_key)
        finish_him = options.delete(:finish_him)
        on_success = options.delete(:on_success)
        on_failure = options.delete(:on_failure)
        on_error = options.delete(:on_error)

        raise Decouplio::Errors::OctoFinishHimIsNotAllowedError if finish_him

        if by_key && by_method
          raise Decouplio::Errors::OctoControversialKeysError.new(
            errored_option: { ctx_key: by_key, method: by_method },
            details: %i[ctx_key method]
          )
        end

        if by_method
          @steps << Decouplio::Steps::OctoByMethod.new(
            octo_name,
            by_method,
            hash_case,
            on_success,
            on_failure,
            on_error,
            finish_him
          )
        elsif by_key
          @steps << Decouplio::Steps::OctoByKey.new(
            octo_name,
            by_key,
            hash_case,
            on_success,
            on_failure,
            on_error,
            finish_him
          )
        else
          raise Decouplio::Errors::RequiredOptionsIsMissingForOctoError.new(
            details: 'ctx_key, method'
          )
        end
      end

      def resq(name = nil, **options)
        unless Decouplio::Const::Flows::MAIN_FLOW.include?(@steps.last.class)
          raise Decouplio::Errors::ResqDefinitionError
        end

        last_step = @steps.delete(@steps.last)

        resq_step = if name.is_a?(Symbol)
                      if Decouplio::Const::Flows::PASS_FLOW.include?(last_step.class)
                        Decouplio::Steps::ResqPass.new(
                          last_step.name,
                          name
                        )
                      elsif Decouplio::Const::Flows::FAIL_FLOW.include?(last_step.class)
                        Decouplio::Steps::ResqFail.new(
                          last_step.name,
                          name
                        )
                      else
                        raise StandardError, 'Most likely it is a bug, please create an issue here https://github.com/differencialx/decouplio/issues'
                      end
                    elsif options.size.positive?
                      if Decouplio::Const::Flows::PASS_FLOW.include?(last_step.class)
                        Decouplio::Steps::ResqWithMappingPass.new(
                          last_step.name,
                          Decouplio::Utils::PrepareResqMappings.call(options)
                        )
                      elsif Decouplio::Const::Flows::FAIL_FLOW.include?(last_step.class)
                        Decouplio::Steps::ResqWithMappingFail.new(
                          last_step.name,
                          Decouplio::Utils::PrepareResqMappings.call(options)
                        )
                      else
                        raise StandardError, 'Most likely it is a bug, please create an issue here https://github.com/differencialx/decouplio/issues'
                      end
                    else
                      raise Decouplio::Errors::InvalidOptionsForResqStep.new(
                        errored_option: "resq -->#{name}<--, -->#{options}<--"
                      )
                    end
        if last_step.is_a?(Decouplio::Steps::BaseOcto)
          last_step._add_resq(resq_step)
          @steps << last_step
        else
          resq_step._add_step_to_resq(last_step)
          @steps << resq_step
        end
      end

      def wrap(name = nil, **options, &block)
        raise Decouplio::Errors::WrapBlockIsNotDefinedError unless block_given?

        wrap_class = options.delete(:klass)
        wrap_method = options.delete(:method)
        if_condition = options.delete(:if)
        unless_condition = options.delete(:unless)
        finish_him = options.delete(:finish_him)
        on_success = options.delete(:on_success)
        on_failure = options.delete(:on_failure)
        on_error = options.delete(:on_error)

        raise Decouplio::Errors::InvalidWrapNameError unless name

        if if_condition && unless_condition
          raise Decouplio::Errors::WrapControversialKeysError.new(
            errored_option: { if: if_condition, unless: unless_condition },
            details: %i[if unless]
          )
        end

        if if_condition
          @steps << Decouplio::Steps::IfConditionPass.new(
            if_condition
          )
        end
        if unless_condition
          @steps << Decouplio::Steps::UnlessConditionPass.new(
            unless_condition
          )
        end

        wrap_block = block

        if wrap_class && wrap_method
          @steps << Decouplio::Steps::WrapWithClassMethod.new(
            name,
            wrap_block,
            wrap_class,
            wrap_method,
            on_success,
            on_failure,
            on_error,
            finish_him
          )
        elsif wrap_class
          @steps << Decouplio::Steps::WrapWithClass.new(
            name,
            wrap_block,
            wrap_class,
            on_success,
            on_failure,
            on_error,
            finish_him
          )
        elsif wrap_method
          raise Decouplio::Errors::WrapKlassMethodError.new(
            errored_option: { method: wrap_method }
          )
        else
          @steps << Decouplio::Steps::Wrap.new(
            name,
            wrap_block,
            on_success,
            on_failure,
            on_error,
            finish_him
          )
        end
      end
    end
  end
end
