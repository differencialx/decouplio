# frozen_string_literal: true

module ReservedMethodNamesCases
  def when_method_brackets
    lambda do |_klass|
      logic do
        step :[]
      end

      def [](**)
        ctx[:key] = 'Success'
      end
    end
  end

  def when_method_success?
    lambda do |_klass|
      logic do
        step :step_one
        fail :success?
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def success?(**)
        ctx[:key] = 'Success'
      end
    end
  end

  def when_method_failure?
    lambda do |_klass|
      logic do
        pass :failure?
      end

      def failure?(**)
        ctx[:key] = 'Success'
      end
    end
  end

  def when_method_fail_action
    lambda do |_klass|
      logic do
        palp :palp_one do
          step :step_one
        end

        octo :fail_action, ctx_key: :some_key do
          on :key, palp: :palp_one
        end
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def fail_action(**)
        ctx[:key] = 'Success'
      end
    end
  end

  def when_method_pass_action
    lambda do |_klass|
      logic do
        wrap :pass_action do
          step :step_one
        end
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def pass_action(**)
        ctx[:key] = 'Success'
      end
    end
  end

  def when_method_append_railway_flow
    lambda do |_klass|
      logic do
        palp :append_railway_flow do
          step :step_one
        end

        octo :octo_name, ctx_key: :some_key do
          on :key, palp: :append_railway_flow
        end
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end
    end
  end

  def when_method_inspect
    lambda do |_klass|
      logic do
        step :step_one
        resq :inspect, error_handler: ArgumentError
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def error_handler(error, **)
        ctx[:error] = error.message
      end
    end
  end

  def when_method_to_s
    lambda do |_klass|
      logic do
        step :step_one
        resq to_s: ArgumentError
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def to_s(error, **)
        ctx[:error] = error.message
      end
    end
  end
end
