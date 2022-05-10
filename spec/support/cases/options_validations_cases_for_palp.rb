# frozen_string_literal: true

module OptionsValidationsCasesForPalp
  def when_palp_other_options_not_allowed
    lambda do |_klass|
      logic do
        palp :palp_one, not_allowed_options: :on_success do
          step :step_one
        end

        octo :strategy_one, ctx_key: :strategy_name do
          on :what_ever_you_want, palp: :palp_one
        end
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end
end
