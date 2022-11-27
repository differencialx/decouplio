# frozen_string_literal: true

module OctoPalpOnSOnFCases
  class OnSOnFAction < Decouplio::Action
    logic do
      step :on_s_on_f_action
    end

    def on_s_on_f_action
      ctx[:on_s_on_f_action] = ctx[:on_s_on_f_act].call
    end
  end

  class OnSOnFService
    def self.call(ctx, _ms, **)
      ctx[:on_s_on_f_service] = ctx[:on_s_on_f_ser].call
    end
  end

  def when_octo_on_s_on_f
    lambda do |_klass|
      logic do
        octo :octo_name, ctx_key: :octo_key, on_success: :octo_success, on_failure: :octo_failure,
                         on_error: :octo_error do
          on :octo1, :octo_one, on_success: :finish_him, on_failure: :octo_one_failure
          on :octo2, OnSOnFAction, on_failure: :finish_him, on_error: :octo_two_error
          on :octo3, OnSOnFService, on_success: :octo_three_success, on_error: :finish_him
          on :octo4, on_success: :FAIL, on_failure: :PASS, on_error: :PASS do
            step :palp_one_step
          end
          on :octo5 do
            step :palp_two_step
          end
        end
        resq :handle_error

        fail :octo_one_failure, finish_him: true
        fail :octo_two_error, finish_him: true
        fail :octo_failure, finish_him: true
        fail :octo_error, finish_him: true
        step :octo_three_success, finish_him: :on_success
        step :octo_success, finish_him: :on_success
      end

      def octo_success
        ctx[:octo_success] = 'Success'
      end

      def octo_failure
        ctx[:octo_failure] = 'Failure'
      end

      def octo_error
        ctx[:octo_error] = 'Error'
      end

      def octo_one
        ctx[:octo_one] = c.oc1.call
      end

      def octo_one_failure
        ctx[:octo_one_failure] = 'Failure'
      end

      def octo_two_error
        ctx[:octo_two_error] = 'Error'
      end

      def octo_three_success
        ctx[:octo_three_success] = 'Success'
      end

      def palp_one_step
        ctx[:palp_one_step] = c.pl1.call
      end

      def palp_two_step
        ctx[:palp_two_step] = c.pl2.call
      end

      def handle_error(error)
        ctx[:handle_error] = error.message
      end
    end
  end

  def when_octo_finish_him_not_allowed
    lambda do |_klass|
      logic do
        octo :octo_name, ctx_key: :octo_key, finish_him: :on_success do
          on :octo1, OnSOnFAction
        end
      end
    end
  end

  def when_octo_step_finish_him_is_not_allowed
    lambda do |_klass|
      logic do
        octo :octo_name, ctx_key: :octo_key do
          on :octo1, OnSOnFAction, finish_him: :on_error
        end
      end
    end
  end
end
