# frozen_string_literal: true

module Decouplio
  module Steps
    class Pass < Decouplio::Steps::BaseStep
      def process(instance)
        instance.railway_flow << @name
        instance.send(@name)
        instance.success = @on_success_resolver
        @on_success
      end
    end
  end
end
