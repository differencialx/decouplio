# frozen_string_literal: true

RSpec.describe 'Octo options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when not allowed option is provided for octo' do
      let(:action_block) { when_octo_not_allowed_option_provided }

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
      let(:action_block) { when_octo_required_keys_were_not_passed }

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

    context 'when octo if and unless present' do
      let(:action_block) { when_octo_if_and_unless_is_present }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:if=>:some_condition?, :unless=>:some_condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Octo::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Octo::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Octo::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::OctoControversialKeysError,
                      message: message
    end

    context 'when palp is not defined for octo' do
      let(:action_block) { when_octo_palp_is_not_defined }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        "\"on :what_ever_you_want_another, palp: :palp_two\"\n"\
        '"on :what_ever_you_want_next, palp: :palp_three"',
        'Next palp(s): "palp_two, palp_three" is not difined',
        Decouplio::Const::Validations::Octo::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Octo::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Octo::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::PalpIsNotDefinedError,
                      message: message
    end
  end
end
