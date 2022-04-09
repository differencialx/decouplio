# frozen_string_literal: true

module WrapCases
  def wrap_without_resq_with_klass_method
    lambda do |_klass|
      logic do
        step :step_one

        wrap :wrap_name, klass: ClassWithWrapperMethod, method: :transaction do
          step :transaction_step_one
          step :transaction_step_two
        end

        step :step_two
      end

      def handler_step(error, **)
        add_error(:wrapper_error, error.message)
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end

      def step_two(integer_param:, **)
        ctx[:result] = ctx[:result].to_i + integer_param
      end

      def transaction_step_one(integer_param:, **)
        ctx[:result] = ctx[:result].to_i + integer_param
      end

      def transaction_step_two(integer_param:, **)
        ctx[:result] = ctx[:result] + integer_param
        StubDummy.call
      end
    end
  end

  def when_wrap_with_klass_method
    lambda do |_klass|
      logic do
        step :step_one

        wrap :wrap_name, klass: ClassWithWrapperMethod, method: :transaction do
          step :transaction_step_one
          step :transaction_step_two
        end
        resq handler_step: ClassWithWrapperMethodError

        step :step_two
      end

      def handler_step(error, **)
        add_error(:wrapper_error, error.message)
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end

      def step_two(integer_param:, **)
        ctx[:result] = ctx[:result].to_i + integer_param
      end

      def transaction_step_one(integer_param:, **)
        ctx[:result] = ctx[:result].to_i + integer_param
      end

      def transaction_step_two(integer_param:, **)
        ctx[:result] = ctx[:result] + integer_param
        StubDummy.call
      end
    end
  end

  def when_wrap_simple
    lambda do |_klass|
      logic do
        wrap :wrap_name do
          step :wrapper_step_one
          step :wrapper_step_two
        end
        resq handler_step: ArgumentError

        step :step_one
        step :step_two
        fail :fail_step
      end

      def handler_step(error, **)
        add_error(:wrapper_error, error.message)
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrapper_step_one(**)
        ctx[:wrapper_step_one] = 'Success'
      end

      def wrapper_step_two(**)
        StubDummy.call
      end

      def fail_step(**)
        ctx[:fail_step] = 'Fail'
      end
    end
  end

  def when_wrap_simple_with_failure_without_failure_track
    lambda do |_klass|
      logic do
        wrap :wrap_name do
          step :wrapper_step_one
          step :wrapper_step_two
          fail :handle_wrap_fail
        end
        resq handler_step: ArgumentError

        step :step_one
        step :step_two
      end

      def handler_step(error, **)
        add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        add_error(:inner_wrapper_fail, 'Inner wrapp error')
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrapper_step_one(**)
        ctx[:wrapper_step_one] = 'Success'
      end

      def wrapper_step_two(**)
        StubDummy.call
      end
    end
  end

  def when_wrap_simple_with_failure_with_failure_track
    lambda do |_klass|
      logic do
        wrap :wrap_name do
          step :wrapper_step_one
          step :wrapper_step_two
          fail :handle_wrap_fail
        end
        resq handler_step: ArgumentError

        step :step_one
        step :step_two
        fail :handle_fail
      end

      def handler_step(error, **)
        add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        add_error(:outer_fail, 'Outer failure error')
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrapper_step_one(**)
        ctx[:wrapper_step_one] = 'Success'
      end

      def wrapper_step_two(**)
        StubDummy.call
      end
    end
  end

  def when_wrap_on_success
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_success: :step_two do
          step :wrapper_step_one
          step :wrapper_step_two
          fail :handle_wrap_fail
        end
        resq handler_step: ArgumentError

        step :step_one
        step :step_two
        fail :handle_fail
      end

      def handler_step(error, **)
        add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        add_error(:outer_fail, 'Outer failure error')
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrapper_step_one(**)
        ctx[:wrapper_step_one] = 'Success'
      end

      def wrapper_step_two(**)
        StubDummy.call
      end
    end
  end

  def when_wrap_on_failure
    lambda do |_klass|
      logic do
        # if on_failure is a step or pass or strategy or wrap(Step#is_step_type?)
        # than call fail_wrap_inner_action for instance to allow
        # not to fail action when inner wrap block was failed
        wrap :wrap_name, on_failure: :step_two do
          step :wrapper_step_one
          step :wrapper_step_two
          fail :handle_wrap_fail
        end
        resq handler_step: ArgumentError

        step :step_one
        step :step_two
        fail :handle_fail
      end

      def handler_step(error, **)
        add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        add_error(:outer_fail, 'Outer failure error')
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrapper_step_one(**)
        ctx[:wrapper_step_one] = 'Success'
      end

      def wrapper_step_two(**)
        StubDummy.call
      end
    end
  end

  def when_wrap_inner_on_success_to_outer_step
    lambda do |_klass|
      logic do
        wrap :wrap_name do
          step :wrapper_step_one, on_success: :step_one
          step :wrapper_step_two
          fail :handle_wrap_fail
        end
        resq handler_step: ArgumentError

        step :step_one
        step :step_two
        fail :handle_fail
      end

      def handler_step(error, **)
        add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        add_error(:outer_fail, 'Outer failure error')
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrapper_step_one(**)
        ctx[:wrapper_step_one] = 'Success'
      end

      def wrapper_step_two(**)
        StubDummy.call
      end
    end
  end

  def when_wrap_inner_on_failure_to_outer_step
    lambda do |_klass|
      logic do
        wrap :some_wrap do
          step :wrapper_step_one, on_failure: :step_one
          step :wrapper_step_two
          fail :handle_wrap_fail
        end
        resq handler_step: ArgumentError

        step :step_one
        step :step_two
        fail :handle_fail
      end

      def handler_step(error, **)
        add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        add_error(:outer_fail, 'Outer failure error')
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrapper_step_one(**)
        ctx[:wrapper_step_one] = 'Success'
      end

      def wrapper_step_two(**)
        StubDummy.call
      end
    end
  end

  def when_wrap_on_success_finish_him
    lambda do |_klass|
      logic do
        wrap :wrap_name, on_success: :finish_him do
          step :wrapper_step_one
          step :wrapper_step_two
          fail :handle_wrap_fail
        end
        resq handler_step: ArgumentError

        step :step_one
        step :step_two
        fail :handle_fail
      end

      def handler_step(error, **)
        add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        add_error(:outer_fail, 'Outer failure error')
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrapper_step_one(**)
        ctx[:wrapper_step_one] = 'Success'
      end

      def wrapper_step_two(**)
        StubDummy.call
      end
    end
  end

  def when_wrap_on_failure_finish_him
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_failure: :finish_him do
          step :wrapper_step_one
          step :wrapper_step_two
          fail :handle_wrap_fail
        end
        resq handler_step: ArgumentError

        step :step_one
        step :step_two
        fail :handle_fail
      end

      def handler_step(error, **)
        add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        add_error(:outer_fail, 'Outer failure error')
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrapper_step_one(**)
        ctx[:wrapper_step_one] = 'Success'
      end

      def wrapper_step_two(**)
        StubDummy.call
      end
    end
  end

  def when_wrap_finish_him_on_success
    lambda do |_klass|
      logic do
        wrap :wrap_name, finish_him: :on_success do
          step :wrapper_step_one
          step :wrapper_step_two
          fail :handle_wrap_fail
        end
        resq handler_step: ArgumentError

        step :step_one
        step :step_two
        fail :handle_fail
      end

      def handler_step(error, **)
        add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        add_error(:outer_fail, 'Outer failure error')
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrapper_step_one(**)
        ctx[:wrapper_step_one] = 'Success'
      end

      def wrapper_step_two(**)
        StubDummy.call
      end
    end
  end

  def when_wrap_finish_him_on_failure
    lambda do |_klass|
      logic do
        wrap :some_wrap, finish_him: :on_failure do
          step :wrapper_step_one
          step :wrapper_step_two
          fail :handle_wrap_fail
        end
        resq handler_step: ArgumentError

        step :step_one
        step :step_two
        fail :handle_fail
      end

      def handler_step(error, **)
        add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        add_error(:outer_fail, 'Outer failure error')
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrapper_step_one(**)
        ctx[:wrapper_step_one] = 'Success'
      end

      def wrapper_step_two(**)
        StubDummy.call
      end
    end
  end

  def when_step_on_success_points_to_wrap
    lambda do |_klass|
      logic do
        step :step_one, on_success: :some_wrap
        step :step_two

        wrap :some_wrap do
          step :wrapper_step_one
        end

        step :step_three
      end

      def step_one(**)
        StubDummy.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def wrapper_step_one(**)
        ctx[:wrapper_step_one] = 'Success'
      end
    end
  end

  def when_step_on_failure_points_to_wrap
    lambda do |_klass|
      logic do
        step :step_one, on_failure: :some_wrap
        step :step_two

        wrap :some_wrap do
          step :wrapper_step_one
        end

        step :step_three
      end

      def step_one(**)
        StubDummy.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def wrapper_step_one(**)
        ctx[:wrapper_step_one] = 'Success'
      end
    end
  end
end
