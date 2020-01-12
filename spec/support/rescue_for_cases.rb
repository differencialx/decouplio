module RescueForCases
  def step_rescue_single_error_class
    lambda do |_klass|
      step :step_one
      rescue_for error_handler: StandardError

      def step_one(string_param:, **)
        StubRaiseError.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end
    end
  end

  def step_rescue_several_error_classes
    lambda do |_klass|
      step :step_one
      rescue_for error_handler: [StandardError, ArgumentError]

      def step_one(string_param:, **)
        StubRaiseError.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end
    end
  end

  def step_rescue_several_handler_methods
    lambda do |_klass|
      step :step_one
      rescue_for error_handler: [StandardError, ArgumentError],
                 another_error_handler: NoMethodError

      def step_one(string_param:, **)
        StubRaiseError.call
      end

      def error_handler(error, **)
        add_error(:step_one_error, error.message)
      end

      def another_error_handler(error, **)
        add_error(:another_error, error.message)
      end
    end
  end

  def step_rescue_undefined_handler_method
    lambda do |_klass|
      step :step_one
      rescue_for another_error_handler: NoMethodError

      def step_one(string_param:, **)
        StubRaiseError.call
      end
    end
  end

  def rescue_for_without_step
    lambda do |_klass|
      rescue_for another_error_handler: NoMethodError

      def another_error_handler(error, **)
        add_error(:another_error, error.message)
      end
    end
  end
end
