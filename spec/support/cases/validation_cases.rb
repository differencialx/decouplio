# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module ValidationCases
  def validations
    lambda do |_klass|
      validate_inputs do
        required(:string_param).filled(:str?)
        required(:integer_param).filled(:int?)
      end
    end
  end

  def custom_validations
    lambda do |_klass|
      validate :first_validation

      def first_validation(string_param:, integer_param:, **)
        return if string_param.to_i == integer_param

        add_error(invalid_string_param: 'Invalid string param')
      end
    end
  end
end
# rubocop:enable Lint/NestedMethodDefinition
