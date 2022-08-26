# frozen_string_literal: true

class OnErrorDoby
  def self.call(ctx, _ms)
    ctx[:some_doby] = ctx[:s1].call
  end
end

module OnErrorCases
  def when_step_on_error_to_step
    lambda do |_klass|
      logic do
        step :step_one, on_error: :step_two
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = c.s1.call
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_step_on_error_to_pass
    lambda do |_klass|
      logic do
        step :step_one, on_error: :PASS
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = c.s1.call
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_step_on_error_to_fail
    lambda do |_klass|
      logic do
        step :step_one, on_error: :FAIL
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = c.s1.call
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_step_on_error_finish_him
    lambda do |_klass|
      logic do
        step :step_one, on_error: :finish_him
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = c.s1.call
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_step_finish_him_on_error
    lambda do |_klass|
      logic do
        step :step_one, finish_him: :on_error
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = c.s1.call
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_fail_on_error_to_step
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_error: :step_two
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_two
      end

      def step_one
        ctx[:step_one] = false
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = c.f1.call
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_fail_on_error_to_pass
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_error: :PASS
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_two
      end

      def step_one
        ctx[:step_one] = false
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = c.f1.call
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_fail_on_error_to_fail
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_error: :FAIL
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_two
      end

      def step_one
        ctx[:step_one] = false
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = c.f1.call
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_fail_on_error_finish_him
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, on_error: :finish_him
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_two
      end

      def step_one
        ctx[:step_one] = false
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = c.f1.call
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_fail_finish_him_on_error
    lambda do |_klass|
      logic do
        step :step_one
        fail :fail_one, finish_him: :on_error
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_two
      end

      def step_one
        ctx[:step_one] = false
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = c.f1.call
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_pass_on_error_to_step
    lambda do |_klass|
      logic do
        pass :pass_one, on_error: :fail_two
        resq handler_one: ArgumentError
        fail :fail_one
        step :step_two
        fail :fail_two
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def pass_one
        ctx[:pass_one] = c.p1.call
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_pass_on_error_to_pass
    lambda do |_klass|
      logic do
        pass :pass_one, on_error: :PASS
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_two
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def pass_one
        ctx[:pass_one] = c.p1.call
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_pass_on_error_to_fail
    lambda do |_klass|
      logic do
        pass :pass_one, on_error: :FAIL
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_two
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def pass_one
        ctx[:pass_one] = c.p1.call
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_pass_on_error_finish_him
    lambda do |_klass|
      logic do
        pass :pass_one, on_error: :finish_him
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_two
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def pass_one
        ctx[:pass_one] = c.p1.call
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_pass_finish_him_on_error
    lambda do |_klass|
      logic do
        pass :pass_one, finish_him: :on_error
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_two
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def pass_one
        ctx[:pass_one] = c.p1.call
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_wrap_on_error_to_step
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_error: :fail_two do
          step :step_one
        end
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_one
        fail :fail_two
      end

      def step_one
        ctx[:step_one] = c.s1.call
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def fail_two
        ctx[:fail_two] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_wrap_on_error_to_pass
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_error: :PASS do
          step :step_one
        end
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = c.s1.call
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_wrap_on_error_to_fail
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_error: :FAIL do
          step :step_one
        end
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = c.s1.call
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_wrap_finish_him_on_error
    lambda do |_klass|
      logic do
        wrap :some_wrap, finish_him: :on_error do
          step :step_one
        end
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = c.s1.call
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_wrap_on_error_finish_him
    lambda do |_klass|
      logic do
        wrap :some_wrap, on_error: :finish_him do
          step :step_one
        end
        resq handler_one: ArgumentError
        step :step_two
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = c.s1.call
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_palp_on_error_to_step_inside_palp
    lambda do |_klass|
      logic do
        octo :octo_name, ctx_key: :octo_key do
          on :octo1 do
            step :palp_step_one, on_error: :palp_step_two
            resq handler_one: ArgumentError
            step :palp_step_two
            fail :palp_fail_one
          end
        end

        step :step_one
        fail :fail_one
      end

      def palp_step_one
        ctx[:palp_step_one] = c.p1.call
      end

      def palp_step_two
        ctx[:palp_step_two] = 'Success'
      end

      def palp_fail_one
        ctx[:palp_fail_one] = 'Failure'
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_palp_on_error_to_pass
    lambda do |_klass|
      logic do
        octo :octo_name, ctx_key: :octo_key do
          on :octo1 do
            step :palp_step_one
            step :palp_step_two, on_error: :PASS
            resq handler_one: ArgumentError
          end
        end

        step :step_one
        fail :fail_one
      end

      def palp_step_one
        ctx[:palp_step_one] = 'Success'
      end

      def palp_step_two
        ctx[:palp_step_two] = c.p2.call
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_palp_on_error_to_fail
    lambda do |_klass|
      logic do
        octo :octo_name, ctx_key: :octo_key do
          on :octo1 do
            step :palp_step_one
            step :palp_step_two
            fail :palp_fail_one, on_error: :FAIL
            resq handler_one: ArgumentError
          end
        end

        step :step_one
        fail :fail_one
      end

      def palp_step_one
        ctx[:palp_step_one] = 'Success'
      end

      def palp_step_two
        ctx[:palp_step_two] = false
      end

      def palp_fail_one
        ctx[:palp_fail_one] = c.pf1.call
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_palp_finish_him_on_error
    lambda do |_klass|
      logic do
        octo :octo_name, ctx_key: :octo_key do
          on :octo1 do
            step :palp_step_one
            step :palp_step_two
            fail :palp_fail_one, finish_him: :on_error
            resq handler_one: ArgumentError
          end
        end

        step :step_one
        fail :fail_one
      end

      def palp_step_one
        ctx[:palp_step_one] = 'Success'
      end

      def palp_step_two
        ctx[:palp_step_two] = false
      end

      def palp_fail_one
        ctx[:palp_fail_one] = c.pf1.call
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handler_one(error, **)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_palp_on_error_finish_him
    lambda do |_klass|
      logic do
        octo :octo_name, ctx_key: :octo_key do
          on :octo1 do
            step :palp_step_one
            step :palp_step_two
            fail :palp_fail_one, on_error: :finish_him
            resq handler_one: ArgumentError
          end
        end

        step :step_one
        fail :fail_one
      end

      def palp_step_one
        ctx[:palp_step_one] = 'Success'
      end

      def palp_step_two
        ctx[:palp_step_two] = false
      end

      def palp_fail_one
        ctx[:palp_fail_one] = c.pf1.call
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handler_one(error)
        ctx[:handler_one] = error.message
      end
    end
  end

  def when_doby_on_error_to_step
    lambda do |_klass|
      logic do
        step OnErrorDoby, on_error: :step_three
        resq handle_error: ArgumentError
        fail :fail_one
        step :step_two
        step :step_three
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def step_three
        ctx[:step_three] = 'Success'
      end

      def handle_error(error)
        ctx[:handle_error] = error.message
      end
    end
  end

  def when_doby_on_error_to_pass
    lambda do |_klass|
      logic do
        step OnErrorDoby, on_error: :PASS
        resq handle_error: ArgumentError
        fail :fail_one
        step :step_two
        step :step_three
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def step_three
        ctx[:step_three] = 'Success'
      end

      def handle_error(error)
        ctx[:handle_error] = error.message
      end
    end
  end

  def when_doby_on_error_to_fail
    lambda do |_klass|
      logic do
        step OnErrorDoby, on_error: :FAIL
        resq handle_error: ArgumentError
        fail :fail_one
        step :step_two
        step :step_three
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def step_three
        ctx[:step_three] = 'Success'
      end

      def handle_error(error)
        ctx[:handle_error] = error.message
      end
    end
  end

  def when_doby_on_error_finish_him
    lambda do |_klass|
      logic do
        step OnErrorDoby, on_error: :finish_him
        resq handle_error: ArgumentError
        step :step_one
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handle_error(error)
        ctx[:handle_error] = error.message
      end
    end
  end

  def when_doby_finish_him_on_error
    lambda do |_klass|
      logic do
        step OnErrorDoby, finish_him: :on_error
        resq handle_error: ArgumentError
        step :step_one
        fail :fail_one
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def handle_error(error)
        ctx[:handle_error] = error.message
      end
    end
  end

  def when_aide_on_error_to_step
    lambda do |_klass|
      logic do
        step :step_one
        fail OnErrorDoby, on_error: :pass_one
        resq handle_error: ArgumentError
        fail :fail_one
        step :step_two
        pass :pass_one
      end

      def step_one
        ctx[:step_one] = false
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def pass_one
        ctx[:pass_one] = 'Success'
      end

      def handle_error(error, **)
        ctx[:handle_error] = error.message
      end
    end
  end

  def when_aide_on_error_to_pass
    lambda do |_klass|
      logic do
        step :step_one
        fail OnErrorDoby, on_error: :PASS
        resq handle_error: ArgumentError
        fail :fail_one
        step :step_two
        pass :pass_one
      end

      def step_one
        ctx[:step_one] = false
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def pass_one
        ctx[:pass_one] = 'Success'
      end

      def handle_error(error)
        ctx[:handle_error] = error.message
      end
    end
  end

  def when_aide_on_error_to_fail
    lambda do |_klass|
      logic do
        step :step_one
        fail OnErrorDoby, on_error: :FAIL
        resq handle_error: ArgumentError
        fail :fail_one
        step :step_two
        pass :pass_one
      end

      def step_one
        ctx[:step_one] = false
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def pass_one
        ctx[:pass_one] = 'Success'
      end

      def handle_error(error)
        ctx[:handle_error] = error.message
      end
    end
  end

  def when_aide_on_error_finish_him
    lambda do |_klass|
      logic do
        step :step_one
        fail OnErrorDoby, on_error: :finish_him
        resq handle_error: ArgumentError
        fail :fail_one
        step :step_two
        pass :pass_one
      end

      def step_one
        ctx[:step_one] = false
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def pass_one
        ctx[:pass_one] = 'Success'
      end

      def handle_error(error, **)
        ctx[:handle_error] = error.message
      end
    end
  end

  def when_aide_finish_him_on_error
    lambda do |_klass|
      logic do
        step :step_one
        fail OnErrorDoby, finish_him: :on_error
        resq handle_error: ArgumentError
        fail :fail_one
        step :step_two
        pass :pass_one
      end

      def step_one
        ctx[:step_one] = false
      end

      def fail_one
        ctx[:fail_one] = 'Failure'
      end

      def step_two
        ctx[:step_two] = 'Success'
      end

      def pass_one
        ctx[:pass_one] = 'Success'
      end

      def handle_error(error)
        ctx[:handle_error] = error.message
      end
    end
  end
end
