# frozen_string_literal: true

class AssignDoby
  def self.call(ctx:, to:, from: nil, value: nil)
    raise 'from/value is empty' unless from || value

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
        ctx[:fail_one] = 'Failure'
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
        ctx[:fail_one] = 'Failure'
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

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_doby_after_step_with_on_success_on_failure_to_doby
    lambda do |_klass|
      logic do
        step :step_one, on_success: :fail_one, on_failure: :AssignDoby
        doby AssignDoby, to: :doby_val, value: 'Some value'

        step :step_two
        fail :fail_one
        step :step_three
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
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

  def when_doby_after_fail_on_success_on_failure
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :fail_two, on_failure: :InitDoby
        step :step_two
        doby InitDoby
        fail :fail_two
      end

      def step_one(outcome:, **)
        ctx[:step_one] = outcome
      end

      def fail_one(fail_one_param:, **)
        ctx[:fail_one] = fail_one_param
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
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

        doby InitDoby
        fail :fail_one
      end

      def step_palp(palp_param:, **)
        ctx[:step_palp] = palp_param
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_doby_after_octo_on_success_on_failure
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :step_palp, on_success: :fail_one, on_failure: :InitDoby
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        step :step_one

        doby InitDoby
        fail :fail_one
      end

      def step_palp(palp_param:, **)
        ctx[:step_palp] = palp_param
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
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
        wrap :some_wrap do
          step :step_one
        end

        doby AssignDoby, from: :step_one, to: :result
        step :step_two
        fail :fail_one
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

  def when_doby_after_wrap_on_success_on_failure
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_success: :fail_one, on_failure: :AssignDoby do
          step :step_one
        end

        doby AssignDoby, from: :step_one, to: :result
        step :step_two
        fail :fail_one
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

  def when_doby_before_resq
    lambda do |_klass|
      logic do
        doby InitDoby
        resq handler: ArgumentError

        fail :fail_one
        step :step_one
      end

      def handler(error, **)
        ctx[:error] = error.message
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_doby_after_resq
    lambda do |_klass|
      logic do
        step :step_one
        resq handler: ArgumentError

        doby AssignDoby, from: :step_one, to: :result
        fail :fail_one
        step :step_two
      end

      def handler(error, **)
        ctx[:error] = error.message
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_doby_inside_palp_before_step
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one, on_failure: :InitDoby
          step :palp_step_two, on_success: :fail_one, on_failure: :step_one
          doby InitDoby
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        step :step_one
        fail :fail_one
      end

      def palp_step_one(palp_param1:, **)
        ctx[:palp_step_one] = palp_param1.call
      end

      def palp_step_two(palp_param2:, **)
        ctx[:palp_step_two] = palp_param2.call
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_doby_inside_wrap
    lambda do |_klass|
      logic do
        wrap :some_wrap do
          step :step_one
          doby InitDoby
        end

        fail :fail_one
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end
end