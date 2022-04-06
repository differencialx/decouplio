# frozen_string_literal: true

module Decouplio
  module Wrappers
    class SimpleWrapper
      def self.wrap(&block)
        raise_no_block_error unless block_given?

        block.call
      end

      def self.raise_no_block_error
        raise ::Decouplio::Errors :NoBlockWrapperError, 'Block should be specified for wrapper'
      end
    end
  end
end
