# frozen_string_literal: true

module ResqInnerActionCases
  ResqInnerAction = Class.new(Decouplio::Action) do
    logic do
      step :inner_step_one
    end

    def inner_step_one(*)
      ctx[:result] = value_to_assign
    end

    private

    def value_to_assign
      StubDummy.call
    end
  end

  def when_resq_for_action_step
    lambda do |_klass|
      logic do
        step ResqInnerActionCases::ResqInnerAction
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_step_on_success_to_success_track
    lambda do |_klass|
      logic do
        step ResqInnerActionCases::ResqInnerAction, on_success: :step_three
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
        step :step_three
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_step_on_failure_to_success_track
    lambda do |_klass|
      logic do
        step ResqInnerActionCases::ResqInnerAction, on_failure: :step_three
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
        step :step_three
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_step_on_success_to_failure_track
    lambda do |_klass|
      logic do
        step ResqInnerActionCases::ResqInnerAction, on_success: :fail_one
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
        step :step_three
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_step_on_failure_to_failure_track
    lambda do |_klass|
      logic do
        step ResqInnerActionCases::ResqInnerAction, on_failure: :fail_two
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
        step :step_three
        fail :fail_two
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_step_complicated_logic
    lambda do |_klass|
      logic do
        step ResqInnerActionCases::ResqInnerAction, on_failure: :fail_two
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one, on_success: :fail_two, on_failure: :step_three
        step :step_three
        fail :fail_two
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(param2:, **)
        ctx[:fail_one] = param2
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_step_on_success_finish_him
    lambda do |_klass|
      logic do
        step ResqInnerActionCases::ResqInnerAction, on_success: :finish_him
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_step_on_failure_finish_him
    lambda do |_klass|
      logic do
        step ResqInnerActionCases::ResqInnerAction, on_failure: :finish_him
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_step_if_condition
    lambda do |_klass|
      logic do
        step ResqInnerActionCases::ResqInnerAction, if: :some_condition?
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end

      def some_condition?(param2:, **)
        param2
      end
    end
  end

  def when_resq_for_action_step_unless_condition
    lambda do |_klass|
      logic do
        step ResqInnerActionCases::ResqInnerAction, unless: :some_condition?
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end

      def some_condition?(param2:, **)
        param2
      end
    end
  end

  def when_resq_for_action_step_on_failure_success_track_if_condition
    lambda do |_klass|
      logic do
        step ResqInnerActionCases::ResqInnerAction,
             if: :some_condition?,
             on_failure: :step_three
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
        step :step_three
        fail :fail_two
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end

      def some_condition?(param2:, **)
        param2
      end
    end
  end

  def when_resq_for_action_step_on_success_failure_track_unless_condition
    lambda do |_klass|
      logic do
        step ResqInnerActionCases::ResqInnerAction,
             unless: :some_condition?,
             on_success: :fail_two
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
        step :step_three
        fail :fail_two
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end

      def some_condition?(param2:, **)
        param2
      end
    end
  end

  def when_resq_for_action_fail
    lambda do |_klass|
      logic do
        step :step_one
        fail ResqInnerActionCases::ResqInnerAction
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_two
        fail :fail_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def fail_three(*)
        ctx[:fail_three] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_fail_on_success_to_success_track
    lambda do |_klass|
      logic do
        step :step_one
        fail ResqInnerActionCases::ResqInnerAction,
             on_success: :step_three
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_two
        step :step_three
        fail :fail_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_two(*)
        ctx[:step_three] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def fail_three(*)
        ctx[:fail_three] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_fail_on_failure_to_success_track
    lambda do |_klass|
      logic do
        step :step_one
        fail ResqInnerActionCases::ResqInnerAction,
             on_failure: :step_three
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_two
        step :step_three
        fail :fail_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_two(*)
        ctx[:step_three] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def fail_three(*)
        ctx[:fail_three] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_fail_on_success_to_failure_track
    lambda do |_klass|
      logic do
        step :step_one
        fail ResqInnerActionCases::ResqInnerAction,
             on_success: :fail_three
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_two
        step :step_three
        fail :fail_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_two(*)
        ctx[:step_three] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def fail_three(*)
        ctx[:fail_three] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_fail_on_failure_to_failure_track
    lambda do |_klass|
      logic do
        step :step_one
        fail ResqInnerActionCases::ResqInnerAction,
             on_failure: :fail_three
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_two
        step :step_three
        fail :fail_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_two(*)
        ctx[:step_three] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def fail_three(*)
        ctx[:fail_three] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_fail_on_success_finish_him
    lambda do |_klass|
      logic do
        step :step_one
        fail ResqInnerActionCases::ResqInnerAction,
             on_success: :finish_him
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_two
        step :step_three
        fail :fail_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_two(*)
        ctx[:step_three] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def fail_three(*)
        ctx[:fail_three] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_fail_on_failure_finish_him
    lambda do |_klass|
      logic do
        step :step_one
        fail ResqInnerActionCases::ResqInnerAction,
             on_failure: :finish_him
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_two
        step :step_three
        fail :fail_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_two(*)
        ctx[:step_three] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def fail_three(*)
        ctx[:fail_three] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_action_fail_if_condition
    lambda do |_klass|
      logic do
        step :step_one
        fail ResqInnerActionCases::ResqInnerAction,
             if: :some_condition?
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_two
        step :step_three
        fail :fail_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_two(*)
        ctx[:step_three] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def fail_three(*)
        ctx[:fail_three] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end

      def some_condition?(param2:, **)
        param2
      end
    end
  end

  def when_resq_for_action_fail_unless_condition
    lambda do |_klass|
      logic do
        step :step_one
        fail ResqInnerActionCases::ResqInnerAction,
             unless: :some_condition?
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_two
        step :step_three
        fail :fail_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_two(*)
        ctx[:step_three] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def fail_three(*)
        ctx[:fail_three] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end

      def some_condition?(param2:, **)
        param2
      end
    end
  end

  def when_resq_for_action_fail_on_failure_success_track_if_condition
    lambda do |_klass|
      logic do
        step :step_one
        fail ResqInnerActionCases::ResqInnerAction,
             on_failure: :step_three,
             if: :some_condition?
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_two
        step :step_three
        fail :fail_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_two(*)
        ctx[:step_three] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def fail_three(*)
        ctx[:fail_three] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end

      def some_condition?(param2:, **)
        param2
      end
    end
  end

  def when_resq_for_action_fail_on_success_failure_track_unless_condition
    lambda do |_klass|
      logic do
        step :step_one
        fail ResqInnerActionCases::ResqInnerAction,
             on_success: :fail_three,
             unless: :some_condition?
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_two
        step :step_three
        fail :fail_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def step_two(*)
        ctx[:step_three] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end

      def step_three(*)
        ctx[:step_three] = 'Success'
      end

      def fail_three(*)
        ctx[:fail_three] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end

      def some_condition?(param2:, **)
        param2
      end
    end
  end

  def when_resq_for_pass_action
    lambda do |_klass|
      logic do
        step :step_one
        pass ResqInnerActionCases::ResqInnerAction
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one(*)
        ctx[:step_one] = 'Success'
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end
    end
  end

  def when_resq_for_pass_action_finish_him
    lambda do |_klass|
      logic do
        step :step_one
        pass ResqInnerActionCases::ResqInnerAction, finish_him: true
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one(*)
        ctx[:step_one] = 'Success'
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end

      def some_condition?(param2:, **)
        param2
      end
    end
  end

  def when_resq_for_pass_finish_him_if_condition
    lambda do |_klass|
      logic do
        step :step_one
        pass ResqInnerActionCases::ResqInnerAction,
             finish_him: true,
             if: :some_condition?
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one(*)
        ctx[:step_one] = 'Success'
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end

      def some_condition?(param2:, **)
        param2
      end
    end
  end

  def when_resq_for_pass_finish_him_unless_condition
    lambda do |_klass|
      logic do
        step :step_one
        pass ResqInnerActionCases::ResqInnerAction,
             finish_him: true,
             unless: :some_condition?
        resq error_handler: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one(*)
        ctx[:step_one] = 'Success'
      end

      def pass_one(param1:, **)
        ctx[:pass_one] = param1
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_one(*)
        ctx[:fail_one] = 'Failure'
      end

      def error_handler(error, **)
        add_error(:error_handler, error.message)
      end

      def some_condition?(param2:, **)
        param2
      end
    end
  end
end
