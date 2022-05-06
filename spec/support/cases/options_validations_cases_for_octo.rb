# frozen_string_literal: true

module OptionsValidationsCasesForOcto
  def when_strategy_not_allowed_option_provided
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :step_one
        end

        octo :strategy_one, ctx_key: :strategy_name, not_allowed_option: :some_option do
          on :what_ever_you_want, palp: :palp_one
        end
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_strategy_required_keys_were_not_passed
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :step_one
        end

        octo :strategy_one do
          on :what_ever_you_want, palp: :palp_one
        end
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_octo_if_and_unless_is_present
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :step_one
        end

        octo :strategy_one, if: :some_condition?, unless: :some_condition? do
          on :what_ever_you_want, palp: :palp_one
        end
      end

      def step_one(**)
        ctx[:result] = 'result'
      end

      def some_condition?(**)
        false
      end
    end
  end
end
