# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module OptionsValidationsCasesForStrategy
  def when_strategy_invalid_on_success_step
    lambda do |_klass|
      logic do
        squad :squad_one do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name, on_success: :step_two do
          on :what_ever_you_want, squad: squad_one
        end
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end
    end
  end

  def when_strategy_invalid_on_failure_step
    lambda do |_klass|
      logic do
        squad :squad_one do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name, on_failure: :step_two do
          on :what_ever_you_want, squad: squad_one
        end
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end
    end
  end

  def when_strategy_finish_him_is_not_a_boolean
    lambda do |_klass|
      logic do
        squad :squad_one do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name, finish_him: 123 do
          on :what_ever_you_want, squad: squad_one
        end
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end
    end
  end

  def when_strategy_finish_him_is_a_boolean
    lambda do |_klass|
      logic do
        squad :squad_one do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name, finish_him: true do
          on :what_ever_you_want, squad: squad_one
        end
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end
    end
  end

  def when_strategy_finish_him_is_not_a_on_success_or_on_failure_symbol
    lambda do |_klass|
      logic do
        squad :squad_one do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name, finish_him: :not_on_success do
          on :what_ever_you_want, squad: squad_one
        end
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end
    end
  end

  def when_step_not_allowed_option_provided
    lambda do |_klass|
      logic do
        squad :squad_one do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name, finish_him: :not_on_success do
          on :what_ever_you_want, squad: squad_one
        end
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end
    end
  end

  def when_step_if_method_is_not_defined
    lambda do |_klass|
      logic do
        squad :squad_one do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name, if: :some_undefined_method do
          on :what_ever_you_want, squad: squad_one
        end
      end

      def step_one(string_param:, **)
        ctx[:result] = string_param
      end
    end
  end

  def when_step_if_method_is_not_defined
    lambda do |_klass|
      logic do
        squad :squad_one do
          step :step_one
        end

        strg :strategy_one, ctx_key: :strategy_name, unless: :some_undefined_method do
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
