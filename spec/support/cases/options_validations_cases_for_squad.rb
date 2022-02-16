# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module OptionsValidationsCasesForSquad
  def when_squad_on_success_not_allowed
    lambda do |_klass|
      logic do
        squad :squad_one, on_success: :step_one do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name do
          on :what_ever_you_want, squad: squad_one
        end
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end
    end
  end

  def when_squad_on_failure_not_allowed
    lambda do |_klass|
      logic do
        squad :squad_one, on_failure: :step_one do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name do
          on :what_ever_you_want, squad: squad_one
        end
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end
    end
  end

  def when_squad_finish_him_not_allowed
    lambda do |_klass|
      logic do
        squad :squad_one, finish_him: :on_success do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name do
          on :what_ever_you_want, squad: squad_one
        end
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end
    end
  end

  def when_squad_other_options_not_allowed
    lambda do |_klass|
      logic do
        squad :squad_one, not_allowed_options: :on_success do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name do
          on :what_ever_you_want, squad: squad_one
        end
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end
    end
  end

  def when_squad_if_not_allowed
    lambda do |_klass|
      logic do
        squad :squad_one, if: :on_success do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name do
          on :what_ever_you_want, squad: squad_one
        end
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end
    end
  end

  def when_squad_unless_not_allowed
    lambda do |_klass|
      logic do
        squad :squad_one, unless: :on_success do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name do
          on :what_ever_you_want, squad: squad_one
        end
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end
    end
  end
end
# rubocop:enable Lint/NestedMethodDefinition
