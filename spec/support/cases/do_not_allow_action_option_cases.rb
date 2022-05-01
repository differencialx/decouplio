# frozen_string_literal: true

module DoNotAllowActionOptionCases
  def when_does_not_allow_action_option_for_wrap
    lambda do |_klass|
      logic do
        wrap :wrap_name, action: :some_action_class do
          step :step_one
          step :step_two
        end
      end

      def step_one(*)
        ctx[:step_one] = 'Success'
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_does_not_allow_action_option_for_octo
    lambda do |_klass|
      logic do
        palp :palp_name do
          step :step_one
          step :step_two
        end

        octo :octo_name, ctx_key: :some_key, action: :some_action_class do
          on :octo_case, palp: :palp_name
        end
      end

      def step_one(*)
        ctx[:step_one] = 'Success'
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_does_not_allow_action_option_for_resq
    lambda do |_klass|
      logic do
        pass :step_one
        resq handler: ArgumentError, action: :some_action_class
      end
    end
  end

  def when_does_not_allow_action_option_for_palp
    lambda do |_klass|
      logic do
        palp :palp_name, action: :some_action_class do
          step :step_one
          step :step_two
        end

        octo :octo_name, ctx_key: :some_key do
          on :octo_case, palp: :palp_name
        end
      end

      def step_one(*)
        ctx[:step_one] = 'Success'
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end
    end
  end
end
