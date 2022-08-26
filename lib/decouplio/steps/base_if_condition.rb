# frozen_string_literal: true

module Decouplio
  module Steps
    class BaseIfCondition < Decouplio::Steps::BaseCondition
      def process(instance)
        instance.send(@condition_method) ? @perform_condition_step : @skip_condition_step
      end
    end
  end
end
