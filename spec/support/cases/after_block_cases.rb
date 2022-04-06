# frozen_string_literal: true

module AfterBlockCases
  def after_block_success
    lambda do |_klass|
      step :step_one

      def step_one(**)
        StubDummy.call
      end
    end
  end

  def after_block_fail
    lambda do |_klass|
      step :step_one
      rescue_for error_handler: StandardError

      def step_one(**)
        StubDummy.call
      end

      def error_handler(error, **)
        add_error(step_one_error: error.message)
      end
    end
  end
end
