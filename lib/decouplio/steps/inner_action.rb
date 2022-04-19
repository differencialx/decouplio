require_relative 'base_step'

module Decouplio
  module Steps
    class InnerAction < Decouplio::Steps::BaseStep
      def initialize(name:, action:, finish_him:, on_success_type:, on_failure_type:)
        @name = name
        @action = action
        @finish_him = finish_him
        @on_success_type = on_success_type
        @on_failure_type = on_failure_type
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        outcome = @action.call(parent_ctx: instance.ctx, parent_railway_flow: instance.railway_flow)

        resolve(outcome: outcome, instance: instance)
      end

      private

      def resolve(outcome:, instance:)
        result = outcome.success?

        unless @finish_him
          unless result
            unless @on_success_type
              instance.errors.merge!(outcome.errors)
              instance.fail_action
            end
          end
          return result
        end

        if @finish_him == :on_success
          if result
            Decouplio::Const::Results::FINISH_HIM
          else
            instance.errors.merge!(outcome.errors)
            Decouplio::Const::Results::FAIL
          end
        elsif @finish_him == :on_failure
          unless result
            instance.fail_action
            instance.errors.merge!(outcome.errors)
            Decouplio::Const::Results::FINISH_HIM
          else
            Decouplio::Const::Results::PASS
          end
        end
      end
    end
  end
end
