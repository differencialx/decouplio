# frozen_string_literal: true

module WrapCases
  class WrapperClass
    def self.call
      StubDummy.call
      yield if block_given?
      StubDummy.call
    end
  end

  def wrap_with_class
    lambda do |_klass|
      logic do
        step :step_one

        wrap :wrap_name, klass: WrapperClass do
          step :wrap_step_one
          step :wrap_step_two
        end

        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def wrap_step_one
        ctx[:wrap_step_one] = c.w1.call
      end

      def wrap_step_two
        ctx[:wrap_step_two] = 'Success'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def wrap_with_class_on_success_to_failure
    lambda do |_klass|
      logic do
        step :step_one

        wrap :wrap_name, klass: WrapperClass, on_success: :fail_one do
          step :wrap_step_one
          step :wrap_step_two
        end

        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def wrap_step_one
        ctx[:wrap_step_one] = c.w1.call
      end

      def wrap_step_two
        ctx[:wrap_step_two] = 'Success'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def wrap_with_class_on_failure_to_success
    lambda do |_klass|
      logic do
        step :step_one

        wrap :wrap_name, klass: WrapperClass, on_failure: :step_two do
          step :wrap_step_one
          step :wrap_step_two
        end

        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def wrap_step_one
        ctx[:wrap_step_one] = c.w1.call
      end

      def wrap_step_two
        ctx[:wrap_step_two] = 'Success'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def wrap_with_class_resq_on_error_finish_him
    lambda do |_klass|
      logic do
        step :step_one

        wrap :wrap_name, klass: WrapperClass, on_error: :finish_him do
          step :wrap_step_one
          step :wrap_step_two
        end
        resq :handle_resq

        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def wrap_step_one
        ctx[:wrap_step_one] = c.w1.call
      end

      def wrap_step_two
        ctx[:wrap_step_two] = 'Success'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handle_resq(error)
        ctx[:handle_resq] = error.message
      end
    end
  end

  def wrap_with_class_resq
    lambda do |_klass|
      logic do
        step :step_one

        wrap :wrap_name, klass: WrapperClass do
          step :wrap_step_one
          step :wrap_step_two
        end
        resq :handle_resq

        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def wrap_step_one
        ctx[:wrap_step_one] = c.w1.call
      end

      def wrap_step_two
        ctx[:wrap_step_two] = 'Success'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handle_resq(error)
        ctx[:handle_resq] = error.message
      end
    end
  end

  def wrap_with_class_finish_him_on_success
    lambda do |_klass|
      logic do
        step :step_one

        wrap :wrap_name, klass: WrapperClass, finish_him: :on_success do
          step :wrap_step_one
          step :wrap_step_two
        end

        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def wrap_step_one
        ctx[:wrap_step_one] = c.w1.call
      end

      def wrap_step_two
        ctx[:wrap_step_two] = 'Success'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def wrap_with_class_from_fail_to_wrap
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :wrap_name

        wrap :wrap_name, klass: WrapperClass do
          step :wrap_step_one
          step :wrap_step_two
        end

        step :step_two
        fail :fail_two
      end

      def step_one
        ctx[:step_one] = false
      end

      def wrap_step_one
        ctx[:wrap_step_one] = c.w1.call
      end

      def wrap_step_two
        ctx[:wrap_step_two] = 'Success'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = c.f1.call
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end
    end
  end
end
