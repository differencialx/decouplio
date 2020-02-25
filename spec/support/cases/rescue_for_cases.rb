# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module RescueForCases
  def step_rescue_single_error_class
    lambda do |_klass|
      step :step_one
      rescue_for error_handler: StandardError

      def step_one(**)
        StubRaiseError.call
      end

      def error_handler(error, **)
        add_error(step_one_error: error.message)
      end
    end
  end

  def step_rescue_several_error_classes
    lambda do |_klass|
      step :step_one
      rescue_for error_handler: [StandardError, ArgumentError]

      def step_one(**)
        StubRaiseError.call
      end

      def error_handler(error, **)
        add_error(step_one_error: error.message)
      end
    end
  end

  # rubocop:disable Metrics/MethodLength
  def step_rescue_several_handler_methods
    lambda do |_klass|
      step :step_one
      rescue_for error_handler: [StandardError, ArgumentError],
                 another_error_handler: NoMethodError

      def step_one(**)
        StubRaiseError.call
      end

      def error_handler(error, **)
        add_error(step_one_error: error.message)
      end

      def another_error_handler(error, **)
        add_error(another_error: error.message)
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def step_rescue_undefined_handler_method
    lambda do |_klass|
      step :step_one
      rescue_for another_error_handler: NoMethodError

      def step_one(**)
        StubRaiseError.call
      end
    end
  end

  def rescue_for_without_step
    lambda do |_klass|
      rescue_for another_error_handler: NoMethodError

      def another_error_handler(error, **)
        add_error(another_error: error.message)
      end
    end
  end

  def resque_with_block_one
    lambda do |_klass|
      rescue_for handle_one: StandardError,
                 handle_two: ArgumentError do
        step :step_one
        step :step_two
      end

      def step_one(**)
        StubRaiseError.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def handle_one(error, **)
        add_error(error_one: error.message)
      end

      def handle_two(error, **)
        add_error(error_two: error.message)
      end
    end
  end

  def resque_with_block_two
    lambda do |_klass|
      rescue_for handle_one: StandardError,
                 handle_two: ArgumentError do
        step :step_one
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        StubRaiseError.call
      end

      def handle_one(error, **)
        add_error(error_one: error.message)
      end

      def handle_two(error, **)
        add_error(error_two: error.message)
      end
    end
  end

  def resque_with_block_finish_him
    lambda do |_klass|
      rescue_for handle_one: StandardError,
                 handle_two: ArgumentError do
        step :step_one, :finish_him
        step :step_two
      end

      def step_one(**)
        StubRaiseError.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def handle_one(error, **)
        add_error(error_one: error.message)
      end

      def handle_two(error, **)
        add_error(error_two: error.message)
      end
    end
  end

  def resque_with_block_on_failure_and_finish_him
    lambda do |_klass|
      rescue_for handle_one: StandardError,
                 handle_two: ArgumentError do
        step :step_one
        step :step_two, :on_failure, :finish_him
        step :step_three
      end

      def step_one(**)
        StubRaiseError.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def handle_one(error, **)
        add_error(error_one: error.message)
      end

      def handle_two(error, **)
        add_error(error_two: error.message)
      end
    end
  end
end
# rubocop:enable Lint/NestedMethodDefinition
