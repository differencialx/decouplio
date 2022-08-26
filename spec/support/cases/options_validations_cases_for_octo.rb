# frozen_string_literal: true

module OptionsValidationsCasesForOcto
  def when_octo_required_keys_were_not_passed
    lambda do |_klass|
      logic do
        octo :strategy_one do
          on :what_ever_you_want do
            step :step_one
          end
        end
      end

      def step_one
        ctx[:result] = 'result'
      end
    end
  end

  def when_octo_if_and_unless_is_present
    lambda do |_klass|
      logic do
        octo :strategy_one, if: :some_condition?, unless: :condition? do
          on :what_ever_you_want do
            step :step_one
          end
        end
      end

      def step_one
        ctx[:result] = 'result'
      end

      def some_condition?
        false
      end

      def condition?
        true
      end
    end
  end

  def when_octo_ctx_key_and_method_are_present
    lambda do |_klass|
      logic do
        octo :strategy_one, ctx_key: :ctx_key, method: :some_method do
          on :what_ever_you_want do
            step :step_one
          end
        end
      end

      def step_one
        ctx[:result] = 'result'
      end

      def some_condition?
        false
      end

      def condition?
        true
      end
    end
  end

  def when_octo_palp_is_not_defined
    lambda do |_klass|
      logic do
        octo :strategy_one, ctx_key: :some_key do
          on :what_ever_you_want do
            step :step_one
          end
          on :what_ever_you_want_another
        end
      end

      def step_one
        ctx[:result] = 'result'
      end

      def some_condition?
        false
      end
    end
  end

  # TODO: add specs
  def when_octo_palp_and_step_is_provided
    lambda do |_klass|
      logic do
        octo :strategy_one, ctx_key: :some_key do
          on :what_ever_you_want do
            step :step_one
          end
          on :what_ever_you_want_another
        end
      end

      def step_one
        ctx[:result] = 'result'
      end

      def some_condition?
        false
      end
    end
  end
end
