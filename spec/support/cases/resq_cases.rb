# frozen_string_literal: true

module ResqCases
  def resq_undefined_handler_method
    lambda do |_klass|
      logic do
        step :step_one
        resq another_error_handler: NoMethodError
      end

      def step_one(**)
        StubDummy.call
      end
    end
  end

  def resq_without_step
    lambda do |_klass|
      logic do
        resq another_error_handler: NoMethodError
      end

      def another_error_handler(error, **)
        add_error(:another_error, error.message)
      end
    end
  end

  def when_resq_does_not_handle_errors_for_next_steps
    lambda do |_klass|
      logic do
        wrap :wrap_name do
          step :wrap_step
        end
        resq handle_error: ArgumentError

        step :step_one
      end

      def step_one(**)
        StubDummy.call
      end

      def wrap_step(**)
        ctx[:result] = 'Success'
      end

      def handle_error(_error, **)
        add_error(:some_error, 'Error message')
      end
    end
  end

  def step_resq_single_error_class
    lambda do |_klass|
      logic do
        step :step_one
        resq error_handler: StandardError
      end

      def step_one(**)
        StubDummy.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end
    end
  end

  def step_resq_single_error_class_success
    lambda do |_klass|
      logic do
        step :step_one
        resq error_handler: StandardError
      end

      def step_one(**)
        StubDummy.call
      end

      def error_handler(error, **)
        ctx[:result] = error.message
      end
    end
  end

  def step_resq_several_error_classes
    lambda do |_klass|
      logic do
        step :step_one
        resq error_handler: [StandardError, ArgumentError]
      end

      def step_one(**)
        StubDummy.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end
    end
  end

  def step_resq_several_handler_methods
    lambda do |_klass|
      logic do
        step :step_one
        resq error_handler: [StandardError, ArgumentError],
             another_error_handler: NoMethodError
      end

      def step_one(**)
        StubDummy.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end

      def another_error_handler(error, **)
        add_error(:another_error, error.message)
      end
    end
  end

  def fail_resq_single_error_class
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_step
        resq error_handler: StandardError
      end

      def step_one(**)
        false
      end

      def error_handler(error, **)
        add_error(:fail_step, error.message)
      end

      def fail_step(**)
        StubDummy.call
      end
    end
  end

  def fail_resq_several_error_classes
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_step
        resq error_handler: [StandardError, ArgumentError]
      end

      def step_one(**)
        false
      end

      def fail_step(**)
        StubDummy.call
      end

      def error_handler(error, **)
        add_error(:fail_step, error.message)
      end
    end
  end

  def fail_resq_several_handler_methods
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_step
        resq error_handler: [StandardError, ArgumentError],
             another_error_handler: NoMethodError
      end

      def step_one(**)
        false
      end

      def fail_step(**)
        StubDummy.call
      end

      def error_handler(error, **)
        add_error(:fail_step, error.message)
      end

      def another_error_handler(error, **)
        add_error(:another_error, error.message)
      end
    end
  end

  def pass_resq_single_error_class
    lambda do |_klass|
      logic do
        pass :step_one
        resq error_handler: StandardError
      end

      def step_one(**)
        StubDummy.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end
    end
  end

  def pass_resq_several_error_classes
    lambda do |_klass|
      logic do
        pass :step_one
        resq error_handler: [StandardError, ArgumentError]
      end

      def step_one(**)
        StubDummy.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end
    end
  end

  def pass_resq_several_handler_methods
    lambda do |_klass|
      logic do
        pass :step_one
        resq error_handler: [StandardError, ArgumentError],
             another_error_handler: NoMethodError
      end

      def step_one(**)
        StubDummy.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end

      def another_error_handler(error, **)
        add_error(:another_error, error.message)
      end
    end
  end

  def strategy_resq_single_error_class
    lambda do |_klass|
      logic do
        palp :palp_name do
          step :step_one
        end

        octo :octo_name, ctx_key: :key do
          on :key_1, palp: :palp_one
        end
        resq handler_method: StandardError
      end

      def step_one(**)
        ctx[:result] = 'Result'
      end
    end
  end

  def when_resq_for_step_with_condition_success_track
    lambda do |_klass|
      logic do
        step :step_one, if: :do_step_one?, on_failure: :success_step
        resq handle_error: ArgumentError
        step :step_two
        fail :fail_step
        step :success_step
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_step(**)
        ctx[:fail_step] = 'Failed step'
      end

      def success_step(**)
        ctx[:success_step] = 'Success step'
      end

      def do_step_one?(**)
        StubDummy.call
      end

      def handle_error(error, **)
        add_error(handled_error: error.message)
      end
    end
  end

  def when_resq_for_step_with_condition_failure_track
    lambda do |_klass|
      logic do
        step :step_one, if: :do_step_one?, on_failure: :final_fail_step
        resq handle_error: ArgumentError
        step :step_two
        fail :fail_step
        step :success_step
        fail :final_fail_step
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_step(**)
        ctx[:fail_step] = 'Failed step'
      end

      def success_step(**)
        ctx[:success_step] = 'Success step'
      end

      def do_step_one?(**)
        StubDummy.call
      end

      def handle_error(error, **)
        add_error(handled_error: error.message)
      end
    end
  end
end
