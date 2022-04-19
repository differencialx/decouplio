require_relative 'base_step'

module Decouplio
  module Steps
    class Step < Decouplio::Steps::BaseStep
      def initialize(name:, finish_him:, on_success_type:, on_failure_type:)
        @name = name
        @finish_him = finish_him
        @on_success_type = on_success_type
        @on_failure_type = on_failure_type
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        result = instance.public_send(@name, **instance.ctx)

        resolve(result: result, instance: instance)
      end

      def resolve(result:, instance:)
        result = !!result

        unless @finish_him
          unless result
            instance.fail_action unless @on_success_type
          end
          return result
        end

        if @finish_him == :on_success
          if result
            Decouplio::Const::Results::FINISH_HIM
          else
            Decouplio::Const::Results::FAIL
          end
        elsif @finish_him == :on_failure
          unless result
            instance.fail_action
            Decouplio::Const::Results::FINISH_HIM
          else
            Decouplio::Const::Results::PASS
          end
        end
      end
    end
  end
end
