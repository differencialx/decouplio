# frozen_string_literal: true

module MetaStoreCases
  def when_action_meta_store
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two
        step :step_three
      end

      def step_one
        ms.status = 400
        ms.add_error(:error1, 'Message 1')
        ms.add_error(:error2, 'Message 2')
        ctx[:step_one] = c.s1.call
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def step_three
        ctx[:step_three] = 'Success'
      end
    end
  end
end
