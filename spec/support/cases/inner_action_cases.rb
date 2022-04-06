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

  def inner_action
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

  def inner_action_on_success
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

  def inner_action_on_failure
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

  def inner_action_finish_him_on_success
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

  def inner_action_finish_him_on_failure
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
end
