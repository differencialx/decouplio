# frozen_string_literal: true

module InnerActionCases
  InnerAction = Class.new(Decouplio::Action) do
    logic do
      step :inner_step
      fail :handle_fail
    end

    def inner_step
      ctx[:result] = c.inner_action_param == 'pass'
    end

    def handle_fail
      ms.add_error(:inner_step_failed, 'Something went wrong inner')
    end
  end

  def when_inner_action_for_step_is_string_class
    lambda do |_klass|
      logic do
        step String
      end
    end
  end

  def when_inner_action_for_fail_is_string_class
    lambda do |_klass|
      logic do
        step :step_one
        fail String
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_inner_action_for_pass_is_string_class
    lambda do |_klass|
      logic do
        pass String
      end
    end
  end

  def when_inner_action
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step InnerAction
        fail :handle_fail
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def handle_fail
        ms.add_error(:outer_step_failed, 'Something went wrong outer')
      end
    end
  end

  def when_inner_action_on_success
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step InnerAction, on_success: :handle_fail
        fail :handle_fail
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def handle_fail
        ms.add_error(:outer_step_failed, 'Something went wrong outer')
      end
    end
  end

  def when_inner_action_on_failure
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step InnerAction, on_failure: :step_one
        fail :handle_fail
        step :step_one
      end

      def step_one
        ctx[:step_one] = 'step_one'
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def handle_fail
        ms.add_error(:outer_step_failed, 'Something went wrong outer')
      end
    end
  end

  def when_inner_action_finish_him_on_success
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step InnerAction, finish_him: :on_success
        fail :handle_fail
        step :step_one
      end

      def step_one
        ctx[:step_one] = 'step_one'
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def handle_fail
        ms.add_error(:outer_step_failed, 'Something went wrong outer')
      end
    end
  end

  def when_inner_action_finish_him_on_failure
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step InnerAction, finish_him: :on_failure
        fail :handle_fail
        step :step_one
      end

      def step_one
        ctx[:step_one] = 'step_one'
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def handle_fail
        ms.add_error(:outer_step_failed, 'Something went wrong outer')
      end
    end
  end

  def when_inner_action_as_fail_step
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        fail InnerAction
        step :step_two
        fail :fail_two
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def step_one
        ctx[:step_one] = c.param2
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_inner_action_as_fail_step_on_success
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        fail InnerAction, on_success: :step_two
        step :step_two
        fail :fail_two
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def step_one
        ctx[:step_one] = c.param2
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_inner_action_as_fail_step_on_failure
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        fail InnerAction, on_failure: :step_two
        step :step_two
        fail :fail_two
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def step_one
        ctx[:step_one] = c.param2
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_inner_action_as_fail_step_on_success_finish_him
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        fail InnerAction, on_success: :finish_him
        step :step_two
        fail :fail_two
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def step_one
        ctx[:step_one] = c.param2
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_inner_action_as_fail_step_on_failure_finish_him
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        fail InnerAction, on_failure: :finish_him
        step :step_two
        fail :fail_two
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def step_one
        ctx[:step_one] = c.param2
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_inner_action_as_fail_step_finish_him_on_success
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        fail InnerAction, finish_him: :on_success
        step :step_two
        fail :fail_two
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def step_one
        ctx[:step_one] = c.param2
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_inner_action_as_fail_step_finish_him_on_failure
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        fail InnerAction, finish_him: :on_failure
        step :step_two
        fail :fail_two
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def step_one
        ctx[:step_one] = c.param2
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_inner_action_as_pass
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        pass InnerAction
        step :step_two
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_inner_action_as_pass_finish_him
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        pass InnerAction, finish_him: true
        step :step_two
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_inner_action_on_success_to_inner_action
    lambda do |_klass|
      logic do
        step :assign_inner_action_param, on_success: :'InnerActionCases::InnerAction'
        step :step_one
        pass InnerActionCases::InnerAction, finish_him: true
        step :step_two
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_inner_action_on_failure_to_inner_action
    lambda do |_klass|
      logic do
        step :step_one
        fail :assign_inner_action_param, on_failure: :'InnerActionCases::InnerAction'
        step :step_two
        pass InnerActionCases::InnerAction, finish_him: true
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_innder_action_if_condition
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        step InnerActionCases::InnerAction, if: :condition?
      end

      def assign_inner_action_param
        ctx[:inner_action_param] = c.param1
      end

      def step_one
        ctx[:step_one] = c.param2
      end

      def condition?
        c.condition
      end
    end
  end
end
