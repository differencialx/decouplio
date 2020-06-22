# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module RailwayCases
  def railway
    lambda do |_klass|
      step :model
      step :check_param1
      down :param1_error
      pass :param2
      step :update_param2, if: :param2_present?
      step :result_step

      step :action1, next: :action3
      step :action2, id: :second_action, next: End

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
end
# rubocop:enable Lint/NestedMethodDefinition
