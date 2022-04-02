# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
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
        strg :strg_one, ctx_key: :strg_1 do
          on :stp1, step: :step_one
          on :stp2, step: :step_two
        end
        resq error_handler: StandardError
      end

      def step_one(**)
        StubDummy.call
      end

      def step_two(**)
        StubDummy.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end
    end
  end

  def strategy_resq_several_error_classes
    lambda do |_klass|
      logic do
        squad :squad_one do
          step :step_one
        end

        strg :strg_one, ctx_key: :strg_1 do
          on :stp1, squad: :squad_one
          on :stp2, step: :step_two
        end
        resq error_handler: [StandardError, ArgumentError]
      end

      def step_one(**)
        StubDummy.call
      end

      def step_two(**)
        StubDummy.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end
    end
  end

  def strategy_resq_inner_squad_resq
    lambda do |_klass|
      logic do
        squad :squad_one do
          step :step_two
          resq inner_rescue: ArgumentError
        end

        strg :strg_one, ctx_key: :strg_1 do
          on :stp1, squad: :squad_one
          on :stp2, step: :step_two
        end
        resq error_handler: ArgumentError
      end

      def step_two(**)
        StubDummy.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end

      def inner_rescue(error, **)
        add_error(:inner_rescue, error.message)
      end
    end
  end
end
# rubocop:enable Lint/NestedMethodDefinition
