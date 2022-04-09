require_relative 'base_step'
require_relative '../processor'

module Decouplio
  module Steps
    class Wrap < Decouplio::Steps::BaseStep
      def initialize(name:, klass:, method:, wrap_flow:, finish_him:)
        @name = name
        @klass = klass
        @method = method
        @wrap_flow = wrap_flow
        @finish_him = finish_him
      end

      def process(instance:)
        instance.append_railway_flow(@name)
        if has_specific_wrap?
          @klass.public_send(@method) do
            Decouplio::Processor.call(instance: instance, **@wrap_flow)
          end
        else
          Decouplio::Processor.call(instance: instance, **@wrap_flow)
        end

        resolve(instance: instance)
      end

      private

      def has_specific_wrap?
        @klass && @method
      end

      def resolve(instance:)
        # The same as for step, but instead of result
        # instance.success? is used
        # binding.pry
        result = instance.success?

        return result unless @finish_him

        if @finish_him == :on_success
          if result
            Decouplio::Const::FINISH_HIM
          else
            Decouplio::Const::FAIL
          end
        elsif @finish_him == :on_failure
          unless result
            instance.fail_action
            Decouplio::Const::FINISH_HIM
          else
            Decouplio::Const::PASS
          end
        end
      end
    end
  end
end
