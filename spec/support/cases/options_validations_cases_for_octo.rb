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

  def when_strategy_if_method_is_not_defined
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :step_one
        end

        octo :strategy_one, ctx_key: :strategy_name, if: :some_undefined_method do
          on :what_ever_you_want, palp: :palp_one
        end
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end

  def when_strategy_unless_method_is_not_defined
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :step_one
        end

        octo :strategy_one, ctx_key: :strategy_name, unless: :some_undefined_method do
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
end