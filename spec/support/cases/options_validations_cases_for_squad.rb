# frozen_string_literal: true

module OptionsValidationsCasesForSquad
  def when_squad_other_options_not_allowed
    lambda do |_klass|
      logic do
        squad :squad_one, not_allowed_options: :on_success do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name do
          on :what_ever_you_want, squad: :squad_one
        end
      end

      def step_one(**)
        ctx[:result] = 'result'
      end
    end
  end
end
