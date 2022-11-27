# frozen_string_literal: true

module ReservedMethodNamesCases
  # []

  def when_method_step_brackets
    lambda do |_klass|
      logic do
        step :[]
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_fail_brackets
    lambda do |_klass|
      logic do
        step :step_one
        fail :[]
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_pass_brackets
    lambda do |_klass|
      logic do
        pass :[]
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_octo_brackets
    lambda do |_klass|
      logic do
        octo :[], method: :octo_key do
          on :one do
            step :step_one
          end
        end
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def octo_key
        :one
      end
    end
  end

  def when_method_wrap_brackets
    lambda do |_klass|
      logic do
        wrap :[] do
          step :step_one
        end
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_resq_general_brackets
    lambda do |_klass|
      logic do
        step :step_one
        resq :[]
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_resq_mapping_brackets
    lambda do |_klass|
      logic do
        step :step_one
        resq :[] => ArgumentError
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_if_brackets
    lambda do |_klass|
      logic do
        step :step_one, if: :[]
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_unless_brackets
    lambda do |_klass|
      logic do
        step :step_one, unless: :[]
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  # inspect

  def when_method_step_inspect
    lambda do |_klass|
      logic do
        step :inspect
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_fail_inspect
    lambda do |_klass|
      logic do
        step :step_one
        fail :inspect
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_pass_inspect
    lambda do |_klass|
      logic do
        pass :inspect
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_octo_inspect
    lambda do |_klass|
      logic do
        octo :inspect, method: :octo_key do
          on :one do
            step :step_one
          end
        end
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def octo_key
        :one
      end
    end
  end

  def when_method_wrap_inspect
    lambda do |_klass|
      logic do
        wrap :inspect do
          step :step_one
        end
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_resq_general_inspect
    lambda do |_klass|
      logic do
        step :step_one
        resq :inspect
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_resq_mapping_inspect
    lambda do |_klass|
      logic do
        step :step_one
        resq inspect: ArgumentError
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_if_inspect
    lambda do |_klass|
      logic do
        step :step_one, if: :inspect
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_unless_inspect
    lambda do |_klass|
      logic do
        step :step_one, unless: :inspect
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  # to_s

  def when_method_step_to_s
    lambda do |_klass|
      logic do
        step :to_s
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_fail_to_s
    lambda do |_klass|
      logic do
        step :step_one
        fail :to_s
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_pass_to_s
    lambda do |_klass|
      logic do
        pass :to_s
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_octo_to_s
    lambda do |_klass|
      logic do
        octo :to_s, method: :octo_key do
          on :one do
            step :step_one
          end
        end
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def octo_key
        :one
      end
    end
  end

  def when_method_wrap_to_s
    lambda do |_klass|
      logic do
        wrap :to_s do
          step :step_one
        end
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_resq_general_to_s
    lambda do |_klass|
      logic do
        step :step_one
        resq :to_s
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_resq_mapping_to_s
    lambda do |_klass|
      logic do
        step :step_one
        resq to_s: ArgumentError
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_if_to_s
    lambda do |_klass|
      logic do
        step :step_one, if: :to_s
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_unless_to_s
    lambda do |_klass|
      logic do
        step :step_one, unless: :to_s
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  # PASS

  def when_method_step_pass
    lambda do |_klass|
      logic do
        step :PASS
      end

      def step_pass
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_fail_pass
    lambda do |_klass|
      logic do
        step :step_one
        fail :PASS
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_pass_pass
    lambda do |_klass|
      logic do
        pass :PASS
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_octo_pass
    lambda do |_klass|
      logic do
        octo :PASS, method: :octo_key do
          on :one do
            step :step_one
          end
        end
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def octo_key
        :one
      end
    end
  end

  def when_method_wrap_pass
    lambda do |_klass|
      logic do
        wrap :PASS do
          step :step_one
        end
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_resq_general_pass
    lambda do |_klass|
      logic do
        step :step_one
        resq :PASS
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_resq_mapping_pass
    lambda do |_klass|
      logic do
        step :step_one
        resq PASS: ArgumentError
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_if_pass
    lambda do |_klass|
      logic do
        step :step_one, if: :PASS
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_unless_pass
    lambda do |_klass|
      logic do
        step :step_one, unless: :PASS
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  # FAIL

  def when_method_step_fail
    lambda do |_klass|
      logic do
        step :FAIL
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_fail_fail
    lambda do |_klass|
      logic do
        step :step_one
        fail :FAIL
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_pass_fail
    lambda do |_klass|
      logic do
        pass :FAIL
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_octo_fail
    lambda do |_klass|
      logic do
        octo :FAIL, method: :octo_key do
          on :one do
            step :step_one
          end
        end
      end

      def step_one
        ctx[:step_one] = 'Success'
      end

      def octo_key
        :one
      end
    end
  end

  def when_method_wrap_fail
    lambda do |_klass|
      logic do
        wrap :FAIL do
          step :step_one
        end
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_resq_general_fail
    lambda do |_klass|
      logic do
        step :step_one
        resq :FAIL
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_resq_mapping_fail
    lambda do |_klass|
      logic do
        step :step_one
        resq FAIL: ArgumentError
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_if_fail
    lambda do |_klass|
      logic do
        step :step_one, if: :FAIL
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_unless_fail
    lambda do |_klass|
      logic do
        step :step_one, unless: :FAIL
      end

      def step_one
        ctx[:step_one] = 'Success'
      end
    end
  end
end
