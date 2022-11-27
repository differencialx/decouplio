# frozen_string_literal: true

module Decouplio
  module Errors
    class BaseError < StandardError
      def initialize(errored_option: nil, details: nil)
        @errored_option = errored_option
        @details = details
        super(message)
      end

      def message
        template % interpolation_values
      end

      def template
        raise NotImplementedError,
              'Please specify error template'
      end

      def interpolation_values
        raise NotImplementedError,
              'Please specify interpolation values for error template'
      end
    end
  end
end
