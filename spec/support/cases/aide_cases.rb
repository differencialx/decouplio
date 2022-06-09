# frozen_string_literal: true

class SemanticAide
  def self.call(ctx:, error_store:, semantic:, error_message:)
    ctx[:before_aide].call
    ctx[:semantic] = semantic
    error_store.add_error(semantic, error_message)

    ctx[:after_aide].call
  end
end

class ResolveAide
  def self.call(ctx:, **)
    ctx[:result] = ctx[:aide_result].call
  end
end

class RandomDoby
  def self.call(ctx:, **)
    ctx[:random] = ctx[:doby].call
  end
end

class ForkAide
  def self.call(ctx:, result:, **)
    ctx[:result] = result
    ctx[:aide].call
  end
end

module AideCases
  # raises an error
  def when_aide_before_step_as_first_step
    lambda do |_klass|
      logic do
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
        step :step_one
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_aide_before_step
    lambda do |_klass|
      logic do
        step :step_one
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
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

  def when_aide_after_step
    lambda do |_klass|
      logic do
        step :step_one
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
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

  def when_aide_after_step_on_success_on_failure_to_doby
    lambda do |_klass|
      logic do
        step :step_one, on_success: :SemanticAide, on_failure: :SemanticAide
        step :step_two
        fail :fail_one
        doby SemanticAide, semantic: :bad_request, error_message: 'Doby message'
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
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

  def when_aide_after_step_on_success_on_failure_to_aide
    lambda do |_klass|
      logic do
        step :step_one, on_success: :SemanticAide, on_failure: :SemanticAide
        step :step_two
        fail :fail_one
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
        doby SemanticAide, semantic: :bad_request, error_message: 'Doby message'
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

  def when_aide_after_step_pass_fail
    lambda do |_klass|
      logic do
        step :step_one, on_success: :FAIL, on_failure: :PASS
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
        doby SemanticAide, semantic: :bad_request, error_message: 'Doby message'
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

  def when_aide_before_fail
    lambda do |_klass|
      logic do
        step :step_one
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
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

  def when_aide_after_fail
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_aide_after_fail_on_success_on_failure_to_doby
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :SemanticAide
        doby SemanticAide, semantic: :bad_request, error_message: 'Doby message'
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def fail_one(f1:, **)
        ctx[:fail_one] = f1.call
      end
    end
  end

  def when_aide_after_fail_on_success_on_failure_to_aide
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_failure: :SemanticAide
        fail :fail_two
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
        doby SemanticAide, semantic: :bad_request, error_message: 'Doby message'
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

  def when_aide_after_fail_pass_fail
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_success: :FAIL, on_failure: :PASS
        doby SemanticAide, semantic: :bad_request, error_message: 'Doby message'
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def fail_one(f1:, **)
        ctx[:fail_one] = f1.call
      end
    end
  end

  def when_aide_before_pass
    lambda do |_klass|
      logic do
        step :step_one
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
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

  def when_aide_after_pass
    lambda do |_klass|
      logic do
        step :step_one
        pass :pass_one
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def pass_one(**)
        ctx[:pass_one] = 'Success'
      end
    end
  end

  def when_aide_before_octo
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one
        end

        step :step_one
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'

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

  def when_aide_after_octo
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'

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

  def when_aide_after_octo_on_success_on_failure_to_doby
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one, on_success: :SemanticAide, on_failure: :SemanticAide
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        step :step_one

        doby SemanticAide, semantic: :bad_request, error_message: 'Doby message'
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'

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

  def when_aide_after_octo_on_success_on_failure_to_aide
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one, on_success: :SemanticAide, on_failure: :SemanticAide
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        step :step_one

        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
        doby SemanticAide, semantic: :bad_request, error_message: 'Doby message'

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

  def when_aide_after_octo_pass_fail
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one, on_success: :FAIL, on_failure: :PASS
        end

        octo :octo_name, ctx_key: :octo_key do
          on :octo1, palp: :palp_one
        end

        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
        doby SemanticAide, semantic: :bad_request, error_message: 'Doby message'

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

  def when_aide_inside_palp
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :palp_step_one, on_success: :FAIL, on_failure: :PASS
          aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
          doby SemanticAide, semantic: :bad_request, error_message: 'Doby message'
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

  def when_aide_with_resq
    lambda do |_klass|
      logic do
        step :step_one
        resq handler_one: ArgumentError
        aide SemanticAide, semantic: :server_error, error_message: 'Something went wrong'
        resq handler_aide_semantic: ArgumentError

        doby RandomDoby

        aide ResolveAide
        resq handler_aide_resolve: ArgumentError

        step :step_two
        fail :fail_one
      end

      def step_one(s1:, **)
        ctx[:step_one] = s1.call
      end

      def handler_one(error, **)
        ctx[:handler_one] = error.message
      end

      def handler_aide_semantic(error, **)
        ctx[:handler_aide_semantic] = error.message
      end

      def handler_aide_resolve(error, **)
        ctx[:handler_aide_resolve] = error.message
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end
    end
  end

  def when_aide_before_wrap
    lambda do |_klass|
      logic do
        step :step_one
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
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

  def when_aide_after_wrap
    lambda do |_klass|
      logic do
        step :step_one
        wrap :some_wrap do
          step :wrap_step_one
        end
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'

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

  def when_aide_after_wrap_on_success_on_failure_to_doby
    lambda do |_klass|
      logic do
        step :step_one
        wrap :some_wrap, on_success: :SemanticAide, on_failure: :SemanticAide do
          step :wrap_step_one
        end
        doby SemanticAide, semantic: :bad_request, error_message: 'Doby message'
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'

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

  def when_aide_after_wrap_on_success_on_failure_to_aide
    lambda do |_klass|
      logic do
        step :step_one
        wrap :some_wrap, on_success: :SemanticAide, on_failure: :SemanticAide do
          step :wrap_step_one
        end
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
        doby SemanticAide, semantic: :bad_request, error_message: 'Doby message'

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

  def when_aide_after_wrap_pass_fail
    lambda do |_klass|
      logic do
        step :step_one
        wrap :some_wrap, on_success: :FAIL, on_failure: :PASS do
          step :wrap_step_one
        end
        doby SemanticAide, semantic: :bad_request, error_message: 'Doby message'
        aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'

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

  def when_aide_inside_wrap
    lambda do |_klass|
      logic do
        step :step_one
        wrap :some_wrap do
          step :wrap_step_one
          doby SemanticAide, semantic: :bad_request, error_message: 'Doby message'
          aide SemanticAide, semantic: :bad_request, error_message: 'Aide message'
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

  def when_aide_on_success_on_failure_to_steps
    lambda do |_klass|
      logic do
        step :step_one
        aide ForkAide, result: 'Result', on_success: :fail_one, on_failure: :step_two
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

  def when_aide_on_success_on_failure_pass_fail
    lambda do |_klass|
      logic do
        step :step_one
        aide ForkAide, result: 'Result', on_success: :FAIL, on_failure: :PASS
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

  def when_aide_on_success_finish_him
    lambda do |_klass|
      logic do
        step :step_one
        aide ForkAide, result: 'Result', on_success: :finish_him
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

  def when_aide_on_failure_finish_him
    lambda do |_klass|
      logic do
        step :step_one
        aide ForkAide, result: 'Result', on_failure: :finish_him
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

  def when_aide_finish_him_true
    lambda do |_klass|
      logic do
        step :step_one
        aide ForkAide, result: 'Result', finish_him: true
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

  def when_aide_finish_him_on_success
    lambda do |_klass|
      logic do
        step :step_one
        aide ForkAide, result: 'Result', finish_him: :on_success
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

  def when_aide_finish_him_on_failure
    lambda do |_klass|
      logic do
        step :step_one
        aide ForkAide, result: 'Result', finish_him: :on_failure
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

  def when_aide_if_condition
    lambda do |_klass|
      logic do
        step :step_one
        aide ForkAide, result: 'Result', if: :condition
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

      def condition(condition:, **)
        condition
      end
    end
  end

  def when_aide_unless_condition
    lambda do |_klass|
      logic do
        step :step_one
        aide ForkAide, result: 'Result', unless: :condition
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

      def condition(condition:, **)
        condition
      end
    end
  end
end