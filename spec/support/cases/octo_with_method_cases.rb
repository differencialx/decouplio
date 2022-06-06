# frozen_string_literal: true

module OctoMethodCases
  def when_octo_with_method
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_one_step
        end

        palp :palp_two do
          step :palp_two_step
        end

        palp :palp_three do
          step :palp_three_step
        end

        step :step_one

        octo :octo_name, method: :octo_key do
          on :octo1, palp: :palp_one
          on :octo2, palp: :palp_two
          on :octo3, palp: :palp_three
        end

        step :step_two
        fail :fail_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def palp_one_step(p1:, **)
        ctx[:palp_one_step] = p1.call
      end

      def palp_two_step(p2:, **)
        ctx[:palp_two_step] = p2.call
      end

      def palp_three_step(p3:, **)
        ctx[:palp_three_step] = p3.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end

      def octo_key(**)
        ctx[:octo_key]
      end
    end
  end

  # raises an error
  def when_octo_with_method_and_ctx_key
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_one_step
        end

        octo :octo_name, method: :octo_key, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end
      end
    end
  end
end
