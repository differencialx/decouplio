# frozen_string_literal: true

module OctoAsStepCases
  class SomeAction < Decouplio::Action
    logic do
      step :some_action_step
    end

    def some_action_step
      ctx[:some_action] = c.some_action_step.call
    end
  end

  class SomeService
    def self.call(ctx, _ms, **_options)
      ctx[:some_service] = ctx.some_service_step.call
    end
  end

  def when_octo_as_step
    lambda do |_klass|
      logic do
        octo :octo_name, ctx_key: :octo_key do
          on :octo1, :step_one
          on :octo2, SomeAction
          on :octo3, SomeService
          on :octo4 do
            step :step_two
          end
        end

        step :final
        fail :fail_final
      end

      def step_one
        ctx[:step_one] = c.s1.call
      end

      def step_two
        ctx[:step_two] = c.s2.call
      end

      def final
        ctx[:final] = 'Success'
      end

      def fail_final
        ctx[:fail_final] = 'Failure'
      end
    end
  end

  def when_octo_validation_error
    lambda do |_klass|
      logic do
        octo :octo_name, ctx_key: :octo_key do
          on :octo1, []
        end
      end
    end
  end
end
