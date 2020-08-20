module IteratorCases
  IterateAction = Class.new(Decouplio::Action) do
    # validate :validate_item

    step :multiply

    def multiply(inner_action_param:, **)
      ctx[:result] = inner_action_param * 2
    end

    def validate_item(inner_action_param:, **)
      return if inner_action_param == 42

      add_error(invalid_inner_action_param: 'Invalid inner_action_param')
    end
  end

  def iterator_by_action_class
    lambda do |_klass|
      iterate :array_to_iterate, IterateAction
    end
  end

  def iterate_by_block
    lambda do |_klass|
      iterate :users do
        validate :validate_user

        step :generate_template
        step :send_email
      end

      def process
        ctx[:users].each do |user|
          template = user.generate_template
          user.send_email(template)
        end
      end

      def generate_template
        ctx[:array] << 1
      end

      def send_email
        ctx[:array][0] = 2
      end
    end
  end
end
