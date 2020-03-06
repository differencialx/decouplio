# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module TagsCases
  def tags_main
    lambda do |_klass|
      step :step_one, tag: :step_one_success
      step :step_two, tag: :step_two_success
      step :step_three, tag: :step_three_success

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        add_error(step_two_error: 'Error')
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end
    end
  end

  def tags_rescue_for_wrap_success
    lambda do |_klass|
      wrap tag: :wrap_success do
        step :step_one, tag: :step_one_success
        step :step_two, tag: :step_two_success
        step :step_three, tag: :step_three_success
      end
      rescue_for handler: StandardError

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def step_three(**)
        StubDummy.call
      end

      def handler(error, **)
        add_error(wrap_error: error.message)
      end
    end
  end

  def tags_nested_action

  end
end
