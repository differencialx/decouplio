# frozen_string_literal: true

require_relative '../const/results'

module Decouplio
  module Steps
    class BaseStep
      attr_reader :name

      def process(*)
        raise NotImplementedError,
              'Please implement process method'
      end
    end
  end
end
