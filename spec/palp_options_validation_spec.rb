# frozen_string_literal: true

RSpec.describe 'Palp options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when not allowed option is provided for palp' do
      let(:action_block) { when_palp_other_options_not_allowed }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '"palp" does not allow any options',
        Decouplio::Const::Validations::Palp::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Palp::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::PalpValidationError,
                      message: message
    end
  end
end
