# frozen_string_literal: true

require_relative 'base_error'

module Decouplio
  module Errors
    class ErrorStoreError < Decouplio::Errors::BaseError
      def template
        'Error store for action and inner action should be the same.'
      end

      def interpolation_values
        []
      end
    end
  end
end
