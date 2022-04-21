# frozen_string_literal: true

RSpec.describe 'Octo options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when not allowed option is provided for strategy' do
      let(:action_block) { when_strategy_not_allowed_option_provided }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:not_allowed_option=>:some_option}',
        '"not_allowed_option" option(s) is not allowed for "octo"',
        Decouplio::Const::Validations::Octo::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Octo::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Octo::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::ExtraKeyForOctoError,
                      message: message
    end

    context 'when requred options were not passed' do
      let(:action_block) { when_strategy_required_keys_were_not_passed }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        'Next option(s) "ctx_key" are required for "octo"',
        Decouplio::Const::Validations::Octo::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Octo::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Octo::REQUIRED_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::RequiredOptionsIsMissingForOctoError,
                      message: message
    end
  end
end
