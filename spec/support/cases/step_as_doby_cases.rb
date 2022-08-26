# frozen_string_literal: true

class AssignStepAsDoby
  def self.call(ctx, _ms, to:, from: nil, value: nil)
    raise 'from/value is empty' unless from || value

    ctx[to] = value || ctx[from]
  end
end

class InitStepAsDoby
  def self.call(ctx, _ms)
    ctx[:init] = StubDummy.call
  end
end

class AddErrorStepAsDoby
  def self.call(ctx, ms, key:, message:)
    ms.add_error(key, message)

    ctx[:doby1]
  end
end

class ForkStepAsDoby
  def self.call(ctx, _ms, result:)
    ctx[:result] = result
    ctx[:doby1].call
  end
end

module StepAsDobyCases
  def when_step_as_doby_after_step
    lambda do |_klass|
      logic do
        step :assign_user
        step AssignStepAsDoby, from: :user, to: :current_user
        step :finish
        fail :fail_one
      end

      def assign_user
        ctx[:user] = c.user_param
        ctx[:assign_user] = c.assign_user
      end

      def finish
        ctx[:result] = "Current user is: #{c.current_user}"
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_before_step
    lambda do |_klass|
      logic do
        step InitStepAsDoby
        step :step_one
        fail :fail_one
      end

      def step_one
        ctx[:result] = c.init * 2
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_after_step_with_on_success_on_failure
    lambda do |_klass|
      logic do
        step :step_one, on_success: :fail_one, on_failure: :step_three
        step AssignStepAsDoby, to: :doby_val, value: 'Some value'

        step :step_two
        fail :fail_one
        step :step_three
      end

      def step_one
        ctx[:step_one] = c.param1
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def step_three
        ctx[:step_three] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_after_step_with_on_success_on_failure_to_doby
    lambda do |_klass|
      logic do
        step :step_one, on_success: :fail_one, on_failure: :AssignStepAsDoby
        step AssignStepAsDoby, to: :doby_val, value: 'Some value'

        step :step_two
        fail :fail_one
        step :step_three
      end

      def step_one
        ctx[:step_one] = c.param1
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def step_three
        ctx[:step_three] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_before_fail
    lambda do |_klass|
      logic do
        step :step_one
        step AssignStepAsDoby, from: :user, to: :current_user
        fail :fail_one
      end

      def step_one
        ctx[:user] = 'Some user'
        ctx[:step_one] = c.outcome
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_after_fail
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one
        step AssignStepAsDoby, from: :user, to: :current_user
      end

      def step_one
        ctx[:user] = 'Some user'
        ctx[:step_one] = c.outcome
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_after_fail_on_success_on_failure
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :fail_two, on_failure: :InitStepAsDoby
        step :step_two
        step InitStepAsDoby
        fail :fail_two
      end

      def step_one
        ctx[:step_one] = c.outcome
      end

      def fail_one
        ctx[:fail_one] = c.fail_one_param
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_step_as_doby_before_pass
    lambda do |_klass|
      logic do
        step InitStepAsDoby
        pass :pass_one
        step :step_one
      end

      def pass_one
        ctx[:pass_one] = c.init
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_step_as_doby_after_pass
    lambda do |_klass|
      logic do
        pass :pass_one
        step AssignStepAsDoby, from: :user, to: :current_user
        step :step_one
      end

      def pass_one
        ctx[:user] = 'Some user'
      end

      def step_one
        ctx[:step_one] = c.current_user
      end
    end
  end

  def when_step_as_doby_before_octo
    lambda do |_klass|
      logic do
        step AssignStepAsDoby, to: :octo_key, value: :octo1

        octo :octo_name, ctx_key: :octo_key do
          on :octo1 do
            step :step_palp
          end
        end
      end

      def step_palp
        ctx[:step_palp] = 'Success'
      end
    end
  end

  def when_step_as_doby_after_octo
    lambda do |_klass|
      logic do
        octo :octo_name, ctx_key: :octo_key do
          on :octo1 do
            step :step_palp
          end
        end

        step :step_one

        step InitStepAsDoby
        fail :fail_one
      end

      def step_palp
        ctx[:step_palp] = c.palp_param
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_before_wrap
    lambda do |_klass|
      logic do
        step InitStepAsDoby
        wrap :some_wrap do
          step :step_one
        end
      end

      def step_one
        ctx[:result] = c.init * 2
      end
    end
  end

  def when_step_as_doby_after_wrap
    lambda do |_klass|
      logic do
        wrap :some_wrap do
          step :step_one
        end

        step AssignStepAsDoby, from: :step_one, to: :result
        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = c.param1
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_after_wrap_on_success_on_failure
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_success: :fail_one, on_failure: :AssignStepAsDoby do
          step :step_one
        end

        step AssignStepAsDoby, from: :step_one, to: :result
        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = c.param1
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_before_resq
    lambda do |_klass|
      logic do
        step InitStepAsDoby
        resq handler: ArgumentError

        fail :fail_one
        step :step_one
      end

      def handler(error)
        ctx[:error] = error.message
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_step_as_doby_after_resq
    lambda do |_klass|
      logic do
        step :step_one
        resq handler: ArgumentError

        step AssignStepAsDoby, from: :step_one, to: :result
        fail :fail_one
        step :step_two
      end

      def handler(error)
        ctx[:error] = error.message
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def step_one
        ctx[:step_one] = c.param1.call
      end

      def step_two
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_step_as_doby_inside_wrap
    lambda do |_klass|
      logic do
        wrap :some_wrap do
          step :step_one
          step InitStepAsDoby
        end

        fail :fail_one
        step :step_two
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_adds_error
    lambda do |_klass|
      logic do
        step :step_one, on_failure: :AddErrorStepAsDoby
        step AddErrorStepAsDoby, key: :step_one_error, message: 'Lol'
        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = false
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_on_success_on_failure_to_steps
    lambda do |_klass|
      logic do
        step ForkStepAsDoby, result: true, on_success: :fail_one, on_failure: :step_one
        step :step_one
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_on_success_on_failure_pass_fail
    lambda do |_klass|
      logic do
        step ForkStepAsDoby, result: 'Result', on_success: :FAIL, on_failure: :PASS
        step :step_one
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_on_success_finish_him
    lambda do |_klass|
      logic do
        step ForkStepAsDoby, result: 'Result', on_success: :finish_him
        step :step_one
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_on_failure_finish_him
    lambda do |_klass|
      logic do
        step ForkStepAsDoby, result: 'Result', on_failure: :finish_him
        step :step_one
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_finish_him_on_success
    lambda do |_klass|
      logic do
        step ForkStepAsDoby, result: 'Result', finish_him: :on_success
        step :step_one
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_finish_him_on_failure
    lambda do |_klass|
      logic do
        step ForkStepAsDoby, result: 'Result', finish_him: :on_failure
        step :step_one
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_as_doby_if_condition
    lambda do |_klass|
      logic do
        step ForkStepAsDoby, result: 'Result', if: :condition
        step :step_one
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def condition
        c.condition
      end
    end
  end

  def when_step_as_doby_unless_condition
    lambda do |_klass|
      logic do
        step ForkStepAsDoby, result: 'Result', unless: :condition
        step :step_one
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def condition
        c.condition
      end
    end
  end
end
