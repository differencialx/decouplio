# frozen_string_literal: true

module ActionCases
  def when_simple_action
    lambda do |_klass|
      logic do
        step :step_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end
    end
  end
end
