# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module GendalfCases
  class GendalfDummy
    def initialize(user, record)
      @user = user
      @record = record
    end

    def index?
      @record.user_id == @user.id
    end
  end

  def gendalf_default
    lambda do |_klass|
      step :init_model
      gendalf GendalfDummy, :index?
      step :step_one

      def init_model(model:, **)
        ctx[:model] = model
      end

      def step_one(**)
        ctx[:result] = 'Success'
      end
    end
  end

  def gendalf_custom_user_key
    lambda do |_klass|
      step :init_model
      gendalf GendalfDummy, :index?, user_key: :current_user
      step :step_one

      def init_model(model:, **)
        ctx[:model] = model
      end

      def step_one(**)
        ctx[:result] = 'Success'
      end
    end
  end

  def gendalf_custom_model_key
    lambda do |_klass|
      step :init_model
      gendalf GendalfDummy, :index?, model_key: :record
      step :step_one

      def init_model(model:, **)
        ctx[:record] = model
      end

      def step_one(**)
        ctx[:result] = 'Success'
      end
    end
  end

  def gendalf_fails_with_error
    lambda do |_klass|
      step :init_model
      gendalf GendalfDummy, :index?
      step :step_one

      def init_model(model:, **)
        ctx[:model] = model
      end

      def step_one(**)
        ctx[:result] = 'Success'
      end
    end
  end
end
