# frozen_string_literal: true

class SemanticDeny
  def self.call(ctx:, error_store:, semantic:, error_message:)
    ctx[:before_deny].call
    ctx[:semantic] = semantic
    error_store.add_error(semantic, error_message)

    ctx[:after_deny].call
  end
end

class ResolveDeny
  def self.call(ctx:, **)
    ctx[:result] = ctx[:deny_result].call
  end
end

class RandomDoby
  def self.call(ctx:, **)
    ctx[:random] = ctx[:doby].call
  end
end

module DenyCases
  # raises an error
  def when_deny_before_step_as_first_step
    lambda do |_klass|
      logic do
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
        step :step_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_deny_before_step
    lambda do |_klass|
      logic do
        step :step_one
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
        step :step_two
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_deny_after_step
    lambda do |_klass|
      logic do
        step :step_one
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
        step :step_two
        fail :fail_one
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_after_step_on_success_on_failure_to_doby
    lambda do |_klass|
      logic do
        step :step_one, on_success: :SemanticDeny, on_failure: :SemanticDeny
        step :step_two
        fail :fail_one
        doby SemanticDeny, semantic: :bad_request, error_message: 'Doby message'
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_after_step_on_success_on_failure_to_deny
    lambda do |_klass|
      logic do
        step :step_one, on_success: :SemanticDeny, on_failure: :SemanticDeny
        step :step_two
        fail :fail_one
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
        doby SemanticDeny, semantic: :bad_request, error_message: 'Doby message'
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_after_step_pass_fail
    lambda do |_klass|
      logic do
        step :step_one, on_success: :FAIL, on_failure: :PASS
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
        doby SemanticDeny, semantic: :bad_request, error_message: 'Doby message'
        step :step_two
        fail :fail_one
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_before_fail
    lambda do |_klass|
      logic do
        step :step_one
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
        fail :fail_one
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_after_fail
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_after_fail_on_success_on_failure_to_doby
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :SemanticDeny
        doby SemanticDeny, semantic: :bad_request, error_message: 'Doby message'
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def fail_one(f1:, **)
        ctx[:fail_one] = f1.call
      end
    end
  end

  def when_deny_after_fail_on_success_on_failure_to_deny
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_failure: :SemanticDeny
        fail :fail_two
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
        doby SemanticDeny, semantic: :bad_request, error_message: 'Doby message'
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def fail_one(f1:, **)
        ctx[:fail_one] = f1.call
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end
  end

  def when_deny_after_fail_pass_fail
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :FAIL, on_failure: :PASS
        doby SemanticDeny, semantic: :bad_request, error_message: 'Doby message'
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def fail_one(f1:, **)
        ctx[:fail_one] = f1.call
      end
    end
  end

  def when_deny_before_pass
    lambda do |_klass|
      logic do
        step :step_one
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
        pass :pass_one
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def pass_one(**)
        ctx[:pass_one] = 'Success'
      end
    end
  end

  def when_deny_after_pass
    lambda do |_klass|
      logic do
        step :step_one
        pass :pass_one
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def pass_one(**)
        ctx[:pass_one] = 'Success'
      end
    end
  end

  def when_deny_before_octo
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one
        end

        step :step_one
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        fail :fail_one
        step :step_two
      end

      def palp_step_one(p1:, **)
        ctx[:palp_step_one] = p1.call
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end
    end
  end

  def when_deny_after_octo
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'

        fail :fail_one
        step :step_one
      end

      def palp_step_one(p1:, **)
        ctx[:palp_step_one] = p1.call
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_after_octo_on_success_on_failure_to_doby
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one, on_success: :SemanticDeny, on_failure: :SemanticDeny
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        step :step_one

        doby SemanticDeny, semantic: :bad_request, error_message: 'Doby message'
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'

        fail :fail_one
      end

      def palp_step_one(p1:, **)
        ctx[:palp_step_one] = p1.call
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_after_octo_on_success_on_failure_to_deny
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one, on_success: :SemanticDeny, on_failure: :SemanticDeny
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        step :step_one

        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
        doby SemanticDeny, semantic: :bad_request, error_message: 'Doby message'

        fail :fail_one
      end

      def palp_step_one(p1:, **)
        ctx[:palp_step_one] = p1.call
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_after_octo_pass_fail
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one, on_success: :FAIL, on_failure: :PASS
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
        doby SemanticDeny, semantic: :bad_request, error_message: 'Doby message'

        step :step_one
        fail :fail_one
      end

      def palp_step_one(p1:, **)
        ctx[:palp_step_one] = p1.call
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_inside_palp
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one, on_success: :FAIL, on_failure: :PASS
          deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
          doby SemanticDeny, semantic: :bad_request, error_message: 'Doby message'
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        step :step_one
        fail :fail_one
      end

      def palp_step_one(p1:, **)
        ctx[:palp_step_one] = p1.call
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_with_resq
    lambda do |_klass|
      logic do
        step :step_one
        resq handler_one: ArgumentError
        deny SemanticDeny, semantic: :server_error, error_message: 'Something went wrong'
        resq handler_deny_semantic: ArgumentError

        doby RandomDoby

        deny ResolveDeny
        resq handler_deny_resolve: ArgumentError

        step :step_two
        fail :fail_one
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def handler_one(error, **)
        ctx[:handler_one] = error.message
      end

      def handler_deny_semantic(error, **)
        ctx[:handler_deny_semantic] = error.message
      end

      def handler_deny_resolve(error, **)
        ctx[:handler_deny_resolve] = error.message
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_before_wrap
    lambda do |_klass|
      logic do
        step :step_one
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
        wrap :some_wrap do
          step :wrap_step_one
        end

        fail :fail_one
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def wrap_step_one(w1:, **)
        ctx[:wrap_step_one] = w1.call
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_after_wrap
    lambda do |_klass|
      logic do
        step :step_one
        wrap :some_wrap do
          step :wrap_step_one
        end
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'

        step :step_two
        fail :fail_one
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrap_step_one(w1:, **)
        ctx[:wrap_step_one] = w1.call
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_after_wrap_on_success_on_failure_to_doby
    lambda do |_klass|
      logic do
        step :step_one
        wrap :some_wrap, on_success: :SemanticDeny, on_failure: :SemanticDeny do
          step :wrap_step_one
        end
        doby SemanticDeny, semantic: :bad_request, error_message: 'Doby message'
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'

        step :step_two
        fail :fail_one
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrap_step_one(w1:, **)
        ctx[:wrap_step_one] = w1.call
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_after_wrap_on_success_on_failure_to_deny
    lambda do |_klass|
      logic do
        step :step_one
        wrap :some_wrap, on_success: :SemanticDeny, on_failure: :SemanticDeny do
          step :wrap_step_one
        end
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
        doby SemanticDeny, semantic: :bad_request, error_message: 'Doby message'

        step :step_two
        fail :fail_one
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrap_step_one(w1:, **)
        ctx[:wrap_step_one] = w1.call
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_after_wrap_pass_fail
    lambda do |_klass|
      logic do
        step :step_one
        wrap :some_wrap, on_success: :FAIL, on_failure: :PASS do
          step :wrap_step_one
        end
        doby SemanticDeny, semantic: :bad_request, error_message: 'Doby message'
        deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'

        step :step_two
        fail :fail_one
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrap_step_one(w1:, **)
        ctx[:wrap_step_one] = w1.call
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_deny_inside_wrap
    lambda do |_klass|
      logic do
        step :step_one
        wrap :some_wrap do
          step :wrap_step_one
          doby SemanticDeny, semantic: :bad_request, error_message: 'Doby message'
          deny SemanticDeny, semantic: :bad_request, error_message: 'Deny message'
        end

        step :step_two
        fail :fail_one
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def wrap_step_one(w1:, **)
        ctx[:wrap_step_one] = w1.call
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end
end
