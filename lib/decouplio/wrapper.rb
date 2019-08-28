module Decouplio
  class Wrapper
    attr_accessor :rescue_for

    def initialize(klass:, method:, &block)
      @klass = klass
      @method = method
      @action_class = Class.new(Decouplio::Action, &block)
    end

    def call(instance)
      block = -> { exec_wrapper(instance) }
      if rescue_for.to_s.strip.length.zero?
        block.call
      else
        eval(rescue_for)
      end
    end

    private

    def exec_wrapper(instance)
      @klass.public_send(@method) do
        @action_class.call(
          instance.params.merge(
            parent_instance: instance,
            wrapper: true
          )
        )
      end
    end
  end
end
