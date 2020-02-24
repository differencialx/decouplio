# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module CustomStatusCases
  def finish_him
    lambda do |_klass|
      step :step_one
      step :step_two, finish_him: true

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end

      def step_two(string_param:, **)
        add_error(something_wrong: 'Something went wrong')
      end
    end
  end
end
# rubocop:enable Lint/NestedMethodDefinition
