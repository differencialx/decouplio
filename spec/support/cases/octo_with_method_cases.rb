# frozen_string_literal: true

module OctoMethodCases
  def when_octo_with_method
    lambda do |_klass|
      logic do
        step :step_one

        octo :octo_name, method: :octo_key do
          on :octo1 do
            step :palp_one_step
          end
          on :octo2 do
            step :palp_two_step
          end
          on :octo3 do
            step :palp_three_step
          end
        end

        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def palp_one_step
        ctx[:palp_one_step] = c.p1.call
      end

      def palp_two_step
        ctx[:palp_two_step] = c.p2.call
      end

      def palp_three_step
        ctx[:palp_three_step] = c.p3.call
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def octo_key
        ctx[:octo_key]
      end
    end
  end

  # raises an error
  def when_octo_with_method_and_ctx_key
    lambda do |_klass|
      logic do
        octo :octo_name, method: :octo_key, ctx_key: :octo_key do
          on :octo1 do
            step :palp_one_step
          end
        end
      end
    end
  end
end
