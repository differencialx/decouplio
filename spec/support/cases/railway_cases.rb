# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module RailwayCases
  def railway
    lambda do |_klass|
      step :model
      step :check_param1
      fail :param1_error
      pass :param2
      step :update_param2, if: :param2_present?
      step :result_step

      step :action1, jump: :action3
      step :action2, tag: :second_action, finish_him: true

      step :action3

      def model(params:, **)
        ctx[:model] = OpenStruct.new(params)
      end

      def check_param1(model:, **)
        !model.param1.nil?
      end

      def param1_error(**)
        add_error(base: 'Param1 invalid')
      end

      def param2(model:, **)
        ctx[:param2] = model.param2
      end

      def update_param2(**)
        ctx[:param2] = 'updated_param2'
      end

      def param2_present?(param2:, **)
        param2
      end

      def result_step(param2:, **)
        result_step = param2 ? :action1 : :second_action
        push(result_step)
      end

      def action1(**)
        ctx[:action1] = true
      end

      def action2(**)
        ctx[:action2] = true
      end

      def action3(**)
        ctx[:action3] = true
      end
    end
  end

  def success_way
    lambda do |_klass|
      step :model
      step :assign_result

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
      step :model
      fail :set_error
      step :assign_result

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
      step :model
      step :assign_result
      fail :fail_one
      fail :fail_two
      fail :fail_three

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
      step :model
      step :assign_result
      fail :fail_one
      fail :fail_two, finish_him: true
      fail :fail_three

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
      step :model
      step :assign_result, if: :assign_result?
      step :final_step

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
      step :model
      step :assign_result
      fail :fail_one, if: :fail_one?
      fail :fail_two

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

  def conditional_execution_for_pass
  end
end
# rubocop:enable Lint/NestedMethodDefinition
