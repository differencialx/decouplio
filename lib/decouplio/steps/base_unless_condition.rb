# frozen_string_literal: true

module Decouplio
  module Steps
    class BaseUnlessCondition < Decouplio::Steps::BaseCondition
      def process(instance)
        instance.send(@condition_method) ? @skip_condition_step : @perform_condition_step
      end
    end
  end
end
