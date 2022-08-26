# frozen_string_literal: true

module Decouplio
  module Steps
    class BaseOcto
      attr_reader :name,
                  :hash_case,
                  :on_success,
                  :on_failure,
                  :on_error,
                  :finish_him,
                  :on_success_resolver,
                  :on_failure_resolver,
                  :on_error_resolver,
                  :resq

      def _add_octo_next_steps(hash_case)
        @hash_case = hash_case
      end

      def _add_resq(resq_step)
        @resq = resq_step
      end
    end
  end
end
