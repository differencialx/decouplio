# frozen_string_literal: true

RSpec.describe 'Octo options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when requred options were not passed' do
      let(:action_block) { when_octo_required_keys_were_not_passed }

      interpolation_values = [
        'Next option(s) "ctx_key, method" are required for "octo"',
        Decouplio::Const::Validations::Octo::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Octo::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Octo::REQUIRED_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::RequiredOptionsIsMissingForOctoError,
                      message: message
    end

    context 'when ctx_key and method is present' do
      let(:action_block) { when_octo_ctx_key_and_method_are_present }

      interpolation_values = [
        '{:ctx_key=>:ctx_key, :method=>:some_method}',
        '"ctx_key" option(s) is not allowed along with "method" option(s)',
        Decouplio::Const::Validations::Octo::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Octo::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Octo::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::OctoControversialKeysError,
                      message: message
    end

    context 'when octo if and unless present' do
      let(:action_block) { when_octo_if_and_unless_is_present }

      interpolation_values = [
        '{:if=>:some_condition?, :unless=>:condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Octo::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Octo::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Octo::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::OctoControversialKeysError,
                      message: message
    end

    context 'when palp is not defined for octo' do
      let(:action_block) { when_octo_palp_is_not_defined }

      interpolation_values = [
        'on :what_ever_you_want_another',
        Decouplio::Const::Validations::Octo::ON_ALLOWED_OPTIONS,
        Decouplio::Const::Validations::Octo::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Octo::PALP_ON_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::OctoCaseIsNotDefinedError,
                      message: message
    end

    context 'when invalid octo step config' do
      let(:action_block) { when_octo_validation_error }

      interpolation_values = [
        '[]'
      ]
      message = Decouplio::Const::Validations::Common::STEP_DEFINITION % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepDefinitionError,
                      message: message
    end
  end
end
