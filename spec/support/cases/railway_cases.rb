# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module RailwayCases
  def success_way
    lambda do |_klass|
      logic do
        step :model
        step :assign_result
      end

      def model(param1:, **)
        ctx[:model] = param1
      end

      def assign_result(model:, **)
        ctx[:result] = model
      end
    end
  end

  def failure_way
    lambda do |_klass|
      logic do
        step :model
        fail :set_error
        step :assign_result
      end

      def model(param1:, **)
        ctx[:model] = param1
      end

      def set_error(**)
        ctx[:error] = 'Error message'
      end

      def assign_result(model:, **)
        ctx[:result] = model
      end
    end
  end

  def multiple_failure_way
    lambda do |_klass|
      logic do
        step :model
        step :assign_result
        fail :fail_one
        fail :fail_two
        fail :fail_three
      end

      def model(param1:, **)
        ctx[:model] = param1
      end

      def fail_one(**)
        ctx[:error1] = 'Error message 1'
      end

      def fail_two(**)
        ctx[:error2] = 'Error message 2'
      end

      def fail_three(**)
        ctx[:error3] = 'Error message 3'
      end

      def assign_result(model:, **)
        ctx[:result] = model
      end
    end
  end

  def failure_with_finish_him
    lambda do |_klass|
      logic do
        step :model
        step :assign_result
        fail :fail_one
        fail :fail_two, finish_him: true
        fail :fail_three
      end

      def model(param1:, **)
        ctx[:model] = param1
      end

      def fail_one(**)
        ctx[:error1] = 'Error message 1'
      end

      def fail_two(**)
        ctx[:error2] = 'Error message 2'
      end

      def fail_three(**)
        ctx[:error3] = 'Error message 3'
      end

      def assign_result(model:, **)
        ctx[:result] = model
      end
    end
  end

  def conditional_execution_for_step
    lambda do |_klass|
      logic do
        step :model
        step :assign_result, if: :assign_result?
        step :final_step
      end

      def model(param1:, **)
        ctx[:model] = param1
      end

      def assign_result?(param2: ,**)
        param2 == true
      end

      def assign_result(model:, **)
        ctx[:result] = model
      end

      def final_step(param1:, **)
        ctx[:final_step] = param1
      end
    end
  end

  def conditional_execution_for_fail
    lambda do |_klass|
      logic do
        step :model
        step :assign_result
        fail :fail_one, if: :fail_one?
        fail :fail_two
      end

      def model(param1:, **)
        ctx[:model] = param1
      end

      def fail_one?(param2:, **)
        param2 == true
      end

      def fail_one(**)
        ctx[:error1] = 'Error message 1'
      end

      def fail_two(**)
        ctx[:error2] = 'Error message 2'
      end

      def assign_result(model:, **)
        ctx[:result] = model
      end
    end
  end

  def pass_way
    lambda do |_klass|
      logic do
        step :model
        pass :pass_step
        step :assign_result
      end

      def model(param1:, **)
        ctx[:model] = param1
      end

      def pass_step(param2:, **)
        ctx[:pass_step] = param2
      end

      def assign_result(model:, **)
        ctx[:result] = model
      end
    end
  end

  def conditional_execution_for_pass
    lambda do |_klass|
      logic do
        step :model
        pass :pass_step, if: :pass_step?
        fail :fail_one
        step :assign_result
      end

      def model(param1:, **)
        ctx[:model] = param1
      end

      def pass_step?(param2:, **)
        param2
      end

      def pass_step(param2:, **)
        ctx[:pass_step] = param2
      end

      def assign_result(model:, **)
        ctx[:result] = model
      end
    end
  end

  def same_step_several_times
    lambda do |_klass|
      logic do
        step :increment
        step :increment
        step :increment
        step :increment
      end

      def increment(param1:, **)
        ctx[:param2] += param1
      end
    end
  end
end
# rubocop:enable Lint/NestedMethodDefinition
