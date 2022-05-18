# frozen_string_literal: true

class AssignDoby
  def self.call(ctx:, from:, to:, value: nil)
    ctx[to] = value || ctx[from]
  end
end

class InitDoby
  def self.call(ctx:)
    ctx[:init] = StubDummy.call
  end
end

module DobyCases
  def when_doby_after_step
    lambda do |_klass|
      logic do
        step :assign_user
        doby AssignDoby, from: :user, to: :current_user
        step :finish
        fail :fail_one
      end

      def assign_user(user_param:, assign_user:, **)
        ctx[:user] = user_param
        ctx[:assign_user] = assign_user
      end

      def finish(current_user:, **)
        ctx[:result] = "Current user is: #{current_user}"
      end

      def fail_one(**)
        ctx[:fail_one] = "Failure"
      end
    end
  end

  def when_doby_before_step
    lambda do |_klass|
      logic do
        doby InitDoby
        step :step_one
        fail :fail_one
      end

      def step_one(init:, **)
        ctx[:result] = init * 2
      end

      def fail_one(**)

      end
    end
  end

  def when_doby_after_step_with_on_success_on_failure
    lambda do |_klass|
      logic do
        step :step_one, on_success: :fail_one, on_failure: :step_three
        doby AssignDoby, to: :doby_val, value: 'Some value'

        step :step_two
        fail :fail_one
        step :step_three
      end

      def step_one(init:, **)
        ctx[:result] = init * 2
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end
    end
  end

  def when_doby_before_fail
    lambda do |_klass|
      logic do
        step :step_one
        doby AssignDoby, from: :user, to: :current_user
        fail :fail_one
      end

      def step_one(outcome:, **)
        ctx[:user] = 'Some user'
        ctx[:step_one] = outcome
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_doby_after_fail
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one
        doby AssignDoby, from: :user, to: :current_user
      end

      def step_one(outcome:, **)
        ctx[:user] = 'Some user'
        ctx[:step_one] = outcome
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_doby_before_pass
    lambda do |_klass|
      logic do
        doby InitDoby
        pass :pass_one
        step :step_one
      end

      def pass_one(init:, **)
        ctx[:pass_one] = init
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_doby_after_pass
    lambda do |_klass|
      logic do
        pass :pass_one
        doby AssignDoby, from: :user, to: :current_user
        step :step_one
      end

      def pass_one(**)
        ctx[:user] = 'Some user'
      end

      def step_one(current_user:, **)
        ctx[:step_one] = current_user
      end
    end
  end

  def when_doby_before_octo
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :step_palp
        end

        doby AssignDoby, to: :octo_key, value: :octo1

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end
      end

      def step_palp(**)
        ctx[:step_palp] = 'Success'
      end
    end
  end

  def when_doby_after_octo
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :step_palp
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        step :step_one

        doby AssignDoby, to: :octo_key, value: :octo1
        fail :fail_one
      end

      def step_palp(**)
        ctx[:step_palp] = 'Success'
      end
    end
  end

  def when_doby_after_octo_on_success_on_failure
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :step_palp, on_success: :fail_one, on_failure: AssignDoby
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        step :step_one

        doby AssignDoby, to: :result, value: 'Success'
        fail :fail_one
      end

      def step_palp(**)
        ctx[:step_palp] = 'Success'
      end
    end
  end

  def when_doby_before_wrap
    lambda do |_klass|
      logic do
        doby InitDoby
        wrap :some_wrap do
          step :step_one
        end
      end

      def step_one(init:, **)
        ctx[:result] = init * 2
      end
    end
  end

  def when_doby_after_wrap
    lambda do |_klass|
      logic do
        doby InitDoby
        wrap :some_wrap do
          step :step_one
        end
      end

      def step_one(init:, **)
        ctx[:result] = init * 2
      end
    end
  end

  def when_doby_before_resq
  end

  def when_doby_after_resq
  end

  def when_doby_inside_palp
  end

  def when_doby_inside_wrap
  end
end
