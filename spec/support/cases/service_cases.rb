# frozen_string_literal: true

class InstanceService
  def self.call(ctx:, **)
    new(ctx: ctx).call
  end

  def initialize(ctx:, **)
    @ctx = ctx
  end

  def call
    @ctx[:result] = @ctx[:one] + @ctx[:two]
    StubDummy.call
  end
end

class ClassService
  def self.call(ctx:, **)
    ctx[:result] = ctx[:one] + ctx[:two]
    StubDummy.call
  end
end

class Service
  def self.call(ctx:, **)
    ctx[:result] = StubDummy.call
  end
end

class AddErrorService
  def self.call(ms:, ctx:)
    ms.add_error(:key, 'ServLol')

    ctx[:serv1]
  end
end

module ServiceCases
  def when_instance_service_as_step
    lambda do |_klass|
      logic do
        step :assign_one
        step :assign_two
        step InstanceService
      end

      def assign_one(**)
        ctx[:one] = 1
      end

      def assign_two(**)
        ctx[:two] = 2
      end
    end
  end

  def when_class_service_as_step
    lambda do |_klass|
      logic do
        step :assign_one
        step :assign_two
        step ClassService
      end

      def assign_one(**)
        ctx[:one] = 1
      end

      def assign_two(**)
        ctx[:two] = 2
      end
    end
  end

  def when_service_as_step_on_success_points_to_it
    lambda do |_klass|
      logic do
        step :step_one, on_success: :Service
        step :step_two
        step Service
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_service_as_step_on_failure_points_to_it
    lambda do |_klass|
      logic do
        step :step_one, on_failure: :Service
        step :step_two
        step Service
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_service_as_step_finish_him
    lambda do |_klass|
      logic do
        step :step_one
        step Service, finish_him: :on_success
        step :step_two
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_service_as_fail
    lambda do |_klass|
      logic do
        step :step_one
        step :step_two
        fail Service
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_service_as_fail_on_success_points_to_it
    lambda do |_klass|
      logic do
        step :step_one, on_success: :Service
        step :step_two
        fail Service
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_service_as_fail_on_failure_points_to_it
    lambda do |_klass|
      logic do
        step :step_one, on_failure: :Service
        step :step_two
        fail :fail_one
        fail Service
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

  def when_service_as_pass
    lambda do |_klass|
      logic do
        step :step_one
        pass Service
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

  def when_service_as_pass_on_success_points_to_it
    lambda do |_klass|
      logic do
        step :step_one, on_success: :Service
        step :step_two
        pass Service
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

  def when_service_as_pass_on_failure_points_to_it
    lambda do |_klass|
      logic do
        step :step_one, on_failure: :Service
        step :step_two
        pass Service
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

  def when_service_as_step_with_resq
    lambda do |_klass|
      logic do
        step Service
        resq handler: ArgumentError
        step :step_one
        fail :fail_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end

      def handler(error, **)
        ctx[:error] = error.message
      end
    end
  end

  def when_service_as_fail_with_resq
    lambda do |_klass|
      logic do
        step :step_one
        fail Service
        resq handler: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def handler(error, **)
        ctx[:error] = error.message
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_service_as_pass_with_resq
    lambda do |_klass|
      logic do
        step :step_one
        pass Service
        resq handler: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def handler(error, **)
        ctx[:error] = error.message
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_service_as_step_inside_wrap
    lambda do |_klass|
      logic do
        wrap :some_wrap do
          step Service
        end
        step :step_one
        fail :fail_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_service_as_step_inside_palp
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :step_one
          step Service
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        step :step_two
        fail :fail_one
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

  def when_service_as_step_inside_palp_on_success_on_failure
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :step_one
          step Service, on_success: :fail_one, on_failure: :step_two
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        step :step_two
        fail :fail_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def handler(error, **)
        ctx[:error] = error.message
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_service_as_step_with_if_condition
    lambda do |_klass|
      logic do
        step :step_one
        step Service, if: :condition?
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def condition?(**)
        ctx[:condition]
      end
    end
  end

  def when_service_as_fail_with_unless_condition
    lambda do |_klass|
      logic do
        step :step_one
        fail Service, unless: :condition?
      end

      def step_one(param1:, **)
        ctx[:step_one] = param1
      end

      def condition?(**)
        ctx[:condition]
      end
    end
  end

  def when_service_as_pass_with_unless_condition
    lambda do |_klass|
      logic do
        step :step_one
        pass Service, unless: :condition?
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def condition?(**)
        ctx[:condition]
      end
    end
  end

  def when_as_step_service_adds_errors
    lambda do |_klass|
      logic do
        step AddErrorService
        step :step_one
        fail :fail_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_as_fail_service_adds_errors
    lambda do |_klass|
      logic do
        step :step_one
        fail AddErrorService
        step :step_two
        fail :fail_one
      end

      def step_one(**)
        ctx[:step_one] = false
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_as_pass_service_adds_errors
    lambda do |_klass|
      logic do
        pass AddErrorService
        step :step_one
        fail :fail_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end
end
