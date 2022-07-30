# frozen_string_literal: true

module OptionsValidationsCasesForResq
  def when_resq_not_allowed_option_is_passed
    lambda do |_klass|
      logic do
        step :step_one
        resq on_success: Exception
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def pass_step(**)
        ctx[:pass_step] = 'pass'
      end
    end
  end

  def when_resq_handler_method_is_not_a_symbol
    lambda do |_klass|
      logic do
        step :step_one
        resq 'Not a symbol' => [NoMethodError]
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_resq_error_class_is_not_inherited_from_exception
    lambda do |_klass|
      logic do
        step :step_one
        resq handle_error: StubDummy
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def handle_error(_, **)
        ms.add_error(:some_error, 'Error message')
      end
    end
  end

  def when_resq_error_classes_is_not_inherited_from_exception
    lambda do |_klass|
      logic do
        step :step_one
        resq handle_error: [StubDummy, StandardError, String]
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def handle_error(_, **)
        ms.add_error(:some_error, 'Error message')
      end
    end
  end

  def when_resq_error_class_is_not_a_class_or_array
    lambda do |_klass|
      logic do
        step :step_one
        resq handle_error: { key: 'val' }
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def handle_error(_, **)
        ms.add_error(:some_error, 'Error message')
      end
    end
  end
end
