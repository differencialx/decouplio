# frozen_string_literal: true

require_relative 'base_step'

module Decouplio
  module Steps
    class Step < Decouplio::Steps::BaseStep
      def initialize(name:, on_success_type:, on_failure_type:)
        @name = name
        @on_success_type = on_success_type
        @on_failure_type = on_failure_type
        super()
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        result = instance.send(@name, **instance.ctx)
        resolve(result: result, instance: instance)
      end

      def resolve(result:, instance:)
        if result
          if [Decouplio::Const::Results::PASS, Decouplio::Const::Results::FAIL].include?(@on_success_type)
            instance.pass_action
            Decouplio::Const::Results::PASS
          elsif @on_success_type == Decouplio::Const::Results::FINISH_HIM
            instance.pass_action
            Decouplio::Const::Results::FINISH_HIM
          end
        elsif @on_failure_type == Decouplio::Const::Results::PASS
          instance.pass_action
          Decouplio::Const::Results::FAIL
        elsif @on_failure_type == Decouplio::Const::Results::FAIL
          instance.fail_action
          Decouplio::Const::Results::FAIL
        elsif @on_failure_type == Decouplio::Const::Results::FINISH_HIM
          instance.fail_action
          Decouplio::Const::Results::FINISH_HIM
        end
      end
    end
  end
end
