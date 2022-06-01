# frozen_string_literal: true

module OnSuccessFailureCases
  def when_step_on_failure_finish_him
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two, on_failure: :finish_him
        step :step_three
      end

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end
    end
  end

  def when_step_on_failure_custom_step
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two, on_failure: :custom_step
        step :step_three
        step :custom_step
        pass :custom_pass_step
        fail :custom_fail_step
      end

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end

      def custom_step(custom_param:, **)
        custom_param
      end

      def custom_pass_step(**)
        ctx[:result] = 'Custom pass step'
      end

      def custom_fail_step(**)
        ctx[:result] = 'Custom fail step'
      end
    end
  end

  def when_step_on_success_finish_him
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two, on_success: :finish_him
        step :step_three
      end

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end
    end
  end

  def when_step_on_success_custom_step
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two, on_success: :custom_step
        step :step_three
        step :custom_step
        pass :custom_pass_step
        fail :custom_fail_step
      end

      def step_one(param1:, **)
        ctx[:result] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end

      def custom_step(custom_param:, **)
        custom_param
      end

      def custom_pass_step(**)
        ctx[:result] = 'Custom pass step'
      end

      def custom_fail_step(**)
        ctx[:result] = 'Custom fail step'
      end
    end
  end

  def when_step_on_failure_custom_step_with_if
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two, on_failure: :custom_fail_step
        step :step_three
        step :custom_step
        pass :custom_pass_step
        fail :custom_fail_step, if: :process_fail_custom_fail_step?
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(param2:, **)
        param2
      end

      def step_three(**)
        ctx[:result] = 'Done'
      end

      def custom_step(custom_param:, **)
        custom_param
      end

      def custom_pass_step(**)
        ctx[:result] = 'Custom pass step'
      end

      def custom_fail_step(**)
        ctx[:result] = 'Custom fail step'
      end

      def process_fail_custom_fail_step?(process_fail_custom_fail_step:, **)
        process_fail_custom_fail_step
      end
    end
  end

  def when_both_options_present_from_failure_to_success_track_on_success
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :step_two, on_failure: :fail_two
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_both_options_present_from_failure_to_success_track_on_failure
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :fail_two, on_failure: :step_two
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_one_option_present_from_failure_to_success_track_on_success
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :step_two
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_one_option_present_from_failure_to_success_track_on_failure
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_failure: :step_two
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_fail_on_success_finish_him_one_option
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :finish_him
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_fail_on_failure_finish_him_one_option
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_failure: :finish_him
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_fail_on_success_finish_him_two_options
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :finish_him, on_failure: :step_two
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_fail_on_failure_finish_him_two_options
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_failure: :finish_him, on_success: :fail_two
        step :step_two
        fail :fail_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def fail_one(*)
        StubDummy.call
      end

      def step_two(*)
        ctx[:step_two] = 'Success'
      end

      def fail_two(*)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_step_on_success_as_pass
    lambda do |_klass|
      logic do
        step :step_one, on_success: :PASS
        fail :fail_one
        step :step_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_on_failure_as_pass
    lambda do |_klass|
      logic do
        step :step_one, on_failure: :PASS
        fail :fail_one
        step :step_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_on_success_on_failure_reverse
    lambda do |_klass|
      logic do
        step :step_one, on_failure: :PASS, on_success: :FAIL
        fail :fail_one
        step :step_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_step_on_success_fail_last_step
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two, on_failure: :PASS, on_success: :FAIL
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(param2:, **)
        ctx[:step_two] = param2
      end
    end
  end

  def when_fail_on_success_pass
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :PASS
        fail :fail_two
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = false
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(param1:, **)
        ctx[:fail_one] = param1
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_fail_on_failure_pass
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_failure: :PASS
        fail :fail_two
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = false
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(param1:, **)
        ctx[:fail_one] = param1
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_fail_on_sucess_on_failure_reverse
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :FAIL, on_failure: :PASS
        fail :fail_two
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = false
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(param1:, **)
        ctx[:fail_one] = param1
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_fail_on_success_on_failure_last_step
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :FAIL, on_failure: :PASS
      end

      def step_one(**)
        ctx[:step_one] = false
      end

      def fail_one(param1:, **)
        ctx[:fail_one] = param1
      end
    end
  end

  def when_wrap_on_success_pass
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_success: :PASS do
          step :step_one
          step :step_two
        end

        step :step_three
        fail :fail_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(param2:, **)
        ctx[:step_two] = param2
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_wrap_on_failure_pass
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_failure: :PASS do
          step :step_one
          step :step_two
        end

        step :step_three
        fail :fail_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(param2:, **)
        ctx[:step_two] = param2
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_wrap_on_sucess_on_failure_reverse
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_success: :FAIL, on_failure: :PASS do
          step :step_one
          step :step_two
        end

        step :step_three
        fail :fail_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(param2:, **)
        ctx[:step_two] = param2
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_wrap_on_success_on_failure_reverse_last_step
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_success: :FAIL, on_failure: :PASS do
          step :step_one
        end
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1.call
      end
    end
  end

  def when_palp_on_success_pass
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one, on_success: :PASS
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        step :step_one
        fail :fail_one
      end

      def palp_step_one(param1:, **)
        ctx[:palp_step_one] = param1
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_palp_on_failure_pass
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one, on_failure: :PASS
          fail :palp_fail_one
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        step :step_one
        fail :fail_one
      end

      def palp_step_one(param1:, **)
        ctx[:palp_step_one] = param1
      end

      def palp_fail_one(**)
        ctx[:palp_fail_one] = 'Failure'
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_palp_on_success_on_failure_reverse
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one, on_success: :FAIL, on_failure: :PASS
          fail :palp_fail_one
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        step :step_one
        fail :fail_one
      end

      def palp_step_one(param1:, **)
        ctx[:palp_step_one] = param1
      end

      def palp_fail_one(**)
        ctx[:palp_fail_one] = 'Failure'
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_palp_on_success_on_failure_last_palp_step
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one, on_success: :FAIL, on_failure: :PASS
        end

        step :step_one

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end
      end

      def palp_step_one(param1:, **)
        ctx[:palp_step_one] = param1
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end
    end
  end

  class OnSOnFCasesAction < Decouplio::Action
    logic do
      step :inner_step
    end

    def inner_step(in1:, **)
      ctx[:inner_step] = in1.call
    end
  end

  def when_action_step_as_step_is_last_step
    lambda do |_klass|
      logic do
        step OnSOnFCasesAction, on_success: :PASS, on_failure: :FAIL
      end
    end
  end

  def when_action_step_as_step_is_last_step_reverse
    lambda do |_klass|
      logic do
        step OnSOnFCasesAction, on_success: :FAIL, on_failure: :PASS
      end
    end
  end

  def when_action_step_as_fail_is_last_step
    lambda do |_klass|
      logic do
        step :step_one
        fail OnSOnFCasesAction, on_success: :PASS, on_failure: :FAIL
      end

      def step_one(**)
        ctx[:step_one] = false
      end
    end
  end

  def when_action_step_as_fail_is_last_step_reverse
    lambda do |_klass|
      logic do
        step :step_one
        fail OnSOnFCasesAction, on_success: :FAIL, on_failure: :PASS
      end

      def step_one(**)
        ctx[:step_one] = false
      end
    end
  end

  class OnSOnFCasesService
    def self.call(ctx:)
      ctx[:inner_step] = ctx[:in1].call
    end
  end

  def when_service_step_as_step_is_last_step
    lambda do |_klass|
      logic do
        step OnSOnFCasesService, on_success: :PASS, on_failure: :FAIL
      end
    end
  end

  def when_service_step_as_step_is_last_step_reverse
    lambda do |_klass|
      logic do
        step OnSOnFCasesService, on_success: :FAIL, on_failure: :PASS
      end
    end
  end

  def when_service_step_as_fail_is_last_step
    lambda do |_klass|
      logic do
        step :step_one
        fail OnSOnFCasesService, on_success: :PASS, on_failure: :FAIL
      end

      def step_one(**)
        ctx[:step_one] = false
      end
    end
  end

  def when_service_step_as_fail_is_last_step_reverse
    lambda do |_klass|
      logic do
        step :step_one
        fail OnSOnFCasesService, on_success: :FAIL, on_failure: :PASS
      end

      def step_one(**)
        ctx[:step_one] = false
      end
    end
  end
end
