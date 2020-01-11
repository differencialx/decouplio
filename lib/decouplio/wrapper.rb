# frozen_string_literal: true

module Decouplio
  class Wrapper
    attr_accessor :rescue_for

    def initialize(klass:, method:, &block)
      @klass = klass
      @method = method
      @action_class = Class.new(Decouplio::Action, &block)
    end

    def call(instance)
      exec_wrapper(instance)
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
