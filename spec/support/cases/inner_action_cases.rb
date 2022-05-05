# frozen_string_literal: true

module InnerActionCases
  InnerAction = Class.new(Decouplio::Action) do
    logic do
      step :inner_step
      fail :handle_fail
    end

    def inner_step(inner_action_param:, **)
      ctx[:result] = inner_action_param == 'pass'
    end

    def handle_fail(**)
      add_error(:inner_step_failed, 'Something went wrong inner')
    end
  end

  def when_inner_action_for_step_is_string_class
    lambda do |_klass|
      logic do
        step :step_one, action: String
      end
    end
  end

  def when_inner_action_for_fail_is_string_class
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, action: String
      end

      def step_one(*)
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_inner_action_for_pass_is_string_class
    lambda do |_klass|
      logic do
        pass :step_one, action: String
      end
    end
  end

  def when_inner_action
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :process_inner_action, action: InnerAction
        fail :handle_fail
      end

      def assign_inner_action_param(param1:, **)
        ctx[:inner_action_param] = param1
      end

      def handle_fail(**)
        add_error(:outer_step_failed, 'Something went wrong outer')
      end
    end
  end

  def when_inner_action_on_success
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :process_inner_action, action: InnerAction, on_success: :handle_fail
        fail :handle_fail
      end

      def assign_inner_action_param(param1:, **)
        ctx[:inner_action_param] = param1
      end

      def handle_fail(**)
        add_error(:outer_step_failed, 'Something went wrong outer')
      end
    end
  end

  def when_inner_action_on_failure
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :process_inner_action, action: InnerAction, on_failure: :step_one
        fail :handle_fail
        step :step_one
      end

      def step_one(**)
        ctx[:step_one] = 'step_one'
      end

      def assign_inner_action_param(param1:, **)
        ctx[:inner_action_param] = param1
      end

      def handle_fail(**)
        add_error(:outer_step_failed, 'Something went wrong outer')
      end
    end
  end

  def when_inner_action_finish_him_on_success
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :process_inner_action, action: InnerAction, finish_him: :on_success
        fail :handle_fail
        step :step_one
      end

      def step_one(**)
        ctx[:step_one] = 'step_one'
      end

      def assign_inner_action_param(param1:, **)
        ctx[:inner_action_param] = param1
      end

      def handle_fail(**)
        add_error(:outer_step_failed, 'Something went wrong outer')
      end
    end
  end

  def when_inner_action_finish_him_on_failure
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :process_inner_action, action: InnerAction, finish_him: :on_failure
        fail :handle_fail
        step :step_one
      end

      def step_one(**)
        ctx[:step_one] = 'step_one'
      end

      def assign_inner_action_param(param1:, **)
        ctx[:inner_action_param] = param1
      end

      def handle_fail(**)
        add_error(:outer_step_failed, 'Something went wrong outer')
      end
    end
  end

  def when_inner_action_as_fail_step
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        fail :fail_one, action: InnerAction
        step :step_two
        fail :fail_two
      end

      def assign_inner_action_param(param1:, **)
        ctx[:inner_action_param] = param1
      end

      def step_one(param2:, **)
        ctx[:step_one] = param2
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_inner_action_as_fail_step_on_success
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        fail :fail_one, action: InnerAction, on_success: :step_two
        step :step_two
        fail :fail_two
      end

      def assign_inner_action_param(param1:, **)
        ctx[:inner_action_param] = param1
      end

      def step_one(param2:, **)
        ctx[:step_one] = param2
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_inner_action_as_fail_step_on_failure
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        fail :fail_one, action: InnerAction, on_failure: :step_two
        step :step_two
        fail :fail_two
      end

      def assign_inner_action_param(param1:, **)
        ctx[:inner_action_param] = param1
      end

      def step_one(param2:, **)
        ctx[:step_one] = param2
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_inner_action_as_fail_step_on_success_finish_him
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        fail :fail_one, action: InnerAction, on_success: :finish_him
        step :step_two
        fail :fail_two
      end

      def assign_inner_action_param(param1:, **)
        ctx[:inner_action_param] = param1
      end

      def step_one(param2:, **)
        ctx[:step_one] = param2
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_inner_action_as_fail_step_on_failure_finish_him
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        fail :fail_one, action: InnerAction, on_failure: :finish_him
        step :step_two
        fail :fail_two
      end

      def assign_inner_action_param(param1:, **)
        ctx[:inner_action_param] = param1
      end

      def step_one(param2:, **)
        ctx[:step_one] = param2
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_inner_action_as_fail_step_finish_him_on_success
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        fail :fail_one, action: InnerAction, finish_him: :on_success
        step :step_two
        fail :fail_two
      end

      def assign_inner_action_param(param1:, **)
        ctx[:inner_action_param] = param1
      end

      def step_one(param2:, **)
        ctx[:step_one] = param2
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_inner_action_as_fail_step_finish_him_on_failure
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        fail :fail_one, action: InnerAction, finish_him: :on_failure
        step :step_two
        fail :fail_two
      end

      def assign_inner_action_param(param1:, **)
        ctx[:inner_action_param] = param1
      end

      def step_one(param2:, **)
        ctx[:step_one] = param2
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_inner_action_as_pass
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        pass :pass_one, action: InnerAction
        step :step_two
      end

      def assign_inner_action_param(param1:, **)
        ctx[:inner_action_param] = param1
      end

      def step_one(*)
        ctx[:step_one] = 'Success'
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_inner_action_as_pass_finish_him
    lambda do |_klass|
      logic do
        step :assign_inner_action_param
        step :step_one
        pass :pass_one, action: InnerAction, finish_him: true
        step :step_two
      end

      def assign_inner_action_param(param1:, **)
        ctx[:inner_action_param] = param1
      end

      def step_one(*)
        ctx[:step_one] = 'Success'
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end
    end
  end
end
