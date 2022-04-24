# frozen_string_literal: true

module OnSuccessFailureCases
  def on_failure_finish_him
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two, on_failure: :finish_him
        step :step_three
      end

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end
    end
  end

  def on_failure_custom_step
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two, on_failure: :custom_step
        step :step_three
        step :custom_step
        pass :custom_pass_step
        fail :custom_fail_step
      end

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end

      def custom_step(custom_param:, **)
        custom_param
      end

      def custom_pass_step(**)
        ctx[:result] = 'Custom pass step'
      end

      def custom_fail_step(**)
        ctx[:result] = 'Custom fail step'
      end
    end
  end

  def on_success_finish_him
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two, on_success: :finish_him
        step :step_three
      end

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end
    end
  end

  def on_success_custom_step
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two, on_success: :custom_step
        step :step_three
        step :custom_step
        pass :custom_pass_step
        fail :custom_fail_step
      end

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end

      def custom_step(custom_param:, **)
        custom_param
      end

      def custom_pass_step(**)
        ctx[:result] = 'Custom pass step'
      end

      def custom_fail_step(**)
        ctx[:result] = 'Custom fail step'
      end
    end
  end

  def on_failure_custom_step_with_if
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two, on_failure: :custom_fail_step
        step :step_three
        step :custom_step
        pass :custom_pass_step
        fail :custom_fail_step, if: :process_fail_custom_fail_step?
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end

      def custom_step(custom_param:, **)
        custom_param
      end

      def custom_pass_step(**)
        ctx[:result] = 'Custom pass step'
      end

      def custom_fail_step(**)
        ctx[:result] = 'Custom fail step'
      end

      def process_fail_custom_fail_step?(process_fail_custom_fail_step:, **)
        process_fail_custom_fail_step
      end
    end
  end

  def when_both_options_present_from_failure_to_success_track_on_success
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :step_two, on_failure: :fail_two
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_both_options_present_from_failure_to_success_track_on_failure
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :fail_two, on_failure: :step_two
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_one_option_present_from_failure_to_success_track_on_success
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :step_two
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_one_option_present_from_failure_to_success_track_on_failure
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_failure: :step_two
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_fail_on_success_finish_him_one_option
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :finish_him
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_fail_on_failure_finish_him_one_option
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_failure: :finish_him
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_fail_on_success_finish_him_two_options
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :finish_him, on_failure: :step_two
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_fail_on_failure_finish_him_two_options
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_failure: :finish_him, on_success: :fail_two
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end
end
