# frozen_string_literal: true

module OctoCasesPalps
  def when_octo_inside_wrap
    lambda do |_klass|
      logic do
        wrap :wrap_for_octo do
          octo :strategy_one, ctx_key: :octo_key do
            on :octo1 do
              step :step_one
              step :step_three, if: :process_step_three?
              step :step_four
            end
            on :octo2 do
              step :step_two
              step :step_three
            end
          end
          step :wrap_step
        end
        resq :handle_resq

        step :final_step
        fail :strategy_failure
      end

      def step_one
        ctx[:step_one] = c.pl1.call
      end

      def step_two
        ctx[:step_two] = c.pl2.call
      end

      def step_three
        ctx[:step_three] = c.pl3.call
      end

      def step_four
        ctx[:step_four] = c.pl4.call
      end

      def wrap_step
        ctx[:wrap_step] = c.ws1.call
      end

      def final_step
        ctx[:final_step] = c.final.call
      end

      def strategy_failure
        ctx[:strategy_failure] = 'Failure'
      end

      def process_step_three?
        c.process_step_three
      end

      def handle_resq(error)
        ctx[:handle_resq] = error.message
      end
    end
  end
end
