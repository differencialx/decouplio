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
        ms.add_error(:wrapper_error, error.message)
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
        ms.add_error(:wrapper_error, error.message)
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
        ms.add_error(:wrapper_error, error.message)
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
        ms.add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        ms.add_error(:inner_wrapper_fail, 'Inner wrapp error')
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
        ms.add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        ms.add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        ms.add_error(:outer_fail, 'Outer failure error')
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
        ms.add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        ms.add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        ms.add_error(:outer_fail, 'Outer failure error')
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
        ms.add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        ms.add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        ms.add_error(:outer_fail, 'Outer failure error')
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
        ms.add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        ms.add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        ms.add_error(:outer_fail, 'Outer failure error')
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
        ms.add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        ms.add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        ms.add_error(:outer_fail, 'Outer failure error')
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
        ms.add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        ms.add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        ms.add_error(:outer_fail, 'Outer failure error')
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
        ms.add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        ms.add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        ms.add_error(:outer_fail, 'Outer failure error')
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
        ms.add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        ms.add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        ms.add_error(:outer_fail, 'Outer failure error')
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
        ms.add_error(:wrapper_error, error.message)
      end

      def handle_wrap_fail(**)
        ms.add_error(:inner_wrapper_fail, 'Inner wrap error')
      end

      def handle_fail(**)
        ms.add_error(:outer_fail, 'Outer failure error')
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

  def when_fail_before_wrap
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one

        wrap :some_wrap do
          step :wrapper_step_one
        end

        fail :fail_two
        step :step_three
        fail :fail_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1.call
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end

      def fail_three(**)
        ctx[:fail_three] = 'Failure'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def wrapper_step_one(param2:, **)
        ctx[:wrapper_step_one] = param2.call
      end
    end
  end

  def when_fail_on_success_points_to_wrap_on_failure_to_fail_track
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :some_wrap

        step :step_two

        wrap :some_wrap, on_failure: :step_three do
          step :wrapper_step_one
        end

        fail :fail_two
        step :step_three
        fail :fail_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1.call
      end

      def step_two(param2:, **)
        ctx[:step_two] = param2.call
      end

      def step_three(param3:, **)
        ctx[:step_three] = param3.call
      end

      def wrapper_step_one(param4:, **)
        ctx[:wrapper_step_one] = param4.call
      end

      def fail_one(param5:, **)
        ctx[:fail_one] = param5.call
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end

      def fail_three(**)
        ctx[:fail_three] = 'Failure'
      end
    end
  end

  def when_fail_on_failure_points_to_wrap_on_success_to_success_track
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_failure: :some_wrap

        step :step_two

        wrap :some_wrap, on_success: :fail_three do
          step :wrapper_step_one
        end

        fail :fail_two
        step :step_three
        fail :fail_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1.call
      end

      def fail_one(param2:, **)
        ctx[:fail_one] = param2.call
      end

      def step_two(param3:, **)
        ctx[:step_two] = param3.call
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end

      def fail_three(**)
        ctx[:fail_three] = 'Failure'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def wrapper_step_one(param4:, **)
        ctx[:wrapper_step_one] = param4.call
      end
    end
  end

  def when_pass_before_wrap
    lambda do |_klass|
      logic do
        pass :pass_one
        fail :fail_one

        wrap :some_wrap do
          step :wrapper_step_one
        end

        step :step_three
      end

      def pass_one(param1:, **)
        ctx[:pass_one] = param1.call
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end

      def wrapper_step_one(param2:, **)
        ctx[:wrapper_step_one] = param2.call
      end

      def step_three(param3:, **)
        ctx[:step_three] = param3.call
      end
    end
  end

  def when_octo_before_wrap
    lambda do |_klass|
      logic do
        palp :palp_name1 do
          step :step_palp1, on_success: :some_wrap, on_failure: :step_three
        end

        palp :palp_name2 do
          step :step_palp2, on_success: :fail_two, on_failure: :some_wrap
        end

        step :step_one
        fail :fail_one, on_failure: :octo_name

        octo :octo_name, ctx_key: :octo_key do
          on :octo_key1, palp: :palp_name1
          on :octo_key2, palp: :palp_name2
        end

        step :step_two

        wrap :some_wrap, on_success: :fail_two, on_failure: :step_three do
          step :wrapper_step_one
        end

        step :step_three
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1.call
      end

      def fail_one(param2:, **)
        ctx[:fail_one] = param2.call
      end

      def step_palp1(param3:, **)
        ctx[:step_palp1] = param3.call
      end

      def step_palp2(param4:, **)
        ctx[:step_palp2] = param4.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrapper_step_one(param5:, **)
        ctx[:wrapper_step_one] = param5.call
      end

      def step_three(param6:, **)
        ctx[:step_three] = param6.call
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_step_resq_before_wrap
    lambda do |_klass|
      logic do
        step :step_one
        resq error_handler_step: ArgumentError

        wrap :wrap_name do
          step :wrap_step_one
        end

        fail :fail_one
        resq error_handler_fail: ArgumentError

        step :step_two

        pass :pass_one
        resq error_handler_pass: ArgumentError

        step :step_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1.call
      end

      def error_handler_step(error, **)
        ctx[:error_handler_step] = error.message
      end

      def wrap_step_one(param2:, **)
        ctx[:wrap_step_one] = param2.call
      end

      def fail_one(param3:, **)
        ctx[:fail_one] = param3.call
      end

      def error_handler_fail(error, **)
        ctx[:error_handler_fail] = error.message
      end

      def step_two(param4:, **)
        ctx[:step_two] = param4.call
      end

      def pass_one(param5:, **)
        ctx[:pass_one] = param5.call
      end

      def error_handler_pass(error, **)
        ctx[:error_handler_pass] = error.message
      end

      def step_three(param6:, **)
        ctx[:step_three] = param6.call
      end
    end
  end

  def when_fail_resq_before_wrap
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one
        resq error_handler_fail: ArgumentError

        wrap :wrap_name do
          step :wrap_step_one
        end

        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1.call
      end

      def fail_one(param2:, **)
        ctx[:fail_one] = param2.call
      end

      def error_handler_fail(error, **)
        ctx[:error_handler_fail] = error.message
      end

      def wrap_step_one(param3:, **)
        ctx[:wrap_step_one] = param3.call
      end

      def step_two(param4:, **)
        ctx[:step_two] = param4.call
      end

      def fail_two(param5:, **)
        ctx[:fail_two] = param5.call
      end
    end
  end

  def when_pass_resq_before_wrap
    lambda do |_klass|
      logic do
        pass :pass_one
        resq error_handler_pass: ArgumentError

        wrap :wrap_one do
          step :wrap_step_one
        end
        resq error_handler_wrap: ArgumentError

        fail :fail_one
        step :step_one
      end

      def pass_one(param1:, **)
        ctx[:pass_one] = param1.call
      end

      def error_handler_pass(error, **)
        ctx[:error_handler_pass] = error.message
      end

      def wrap_step_one(param2:, **)
        ctx[:wrap_step_one] = param2.call
      end

      def error_handler_wrap(error, **)
        ctx[:error_handler_wrap] = error.message
      end

      def fail_one(param3:, **)
        ctx[:fail_one] = param3.call
      end

      def step_one(param4:, **)
        ctx[:step_one] = param4.call
      end
    end
  end
end
