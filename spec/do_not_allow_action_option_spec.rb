# frozen_string_literal: true

RSpec.describe 'Decouplio::Action do not allow action option' do
  include_context 'with basic spec setup'

  describe '#call' do
    context 'when wrap' do
      let(:action_block) { when_does_not_allow_action_option_for_wrap }

      interpolation_values = [
        '{:action=>:some_action_class}',
        'Please check if wrap option is allowed',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL
      ]

      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::ExtraKeyForWrapError,
                      message: message
    end
  end

  context 'when octo' do
    let(:action_block) { when_does_not_allow_action_option_for_octo }

    interpolation_values = [
      '{:action=>:some_action_class}',
      '"action" option(s) is not allowed for "octo"',
      Decouplio::Const::Validations::Octo::ALLOWED_OPTIONS_MESSAGE,
      Decouplio::Const::Validations::Octo::MANUAL_URL
    ]

    message = Decouplio::Const::Validations::Octo::VALIDATION_ERROR_MESSAGE % interpolation_values

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::ExtraKeyForOctoError,
                    message: message
  end

  context 'when resq' do
    let(:action_block) { when_does_not_allow_action_option_for_resq }

    interpolation_values = [
      'Invalid handler class value "some_action_class"',
      'Please specify exception class(es) for "action"',
      Decouplio::Const::Validations::Resq::ALLOWED_OPTIONS_MESSAGE,
      Decouplio::Const::Validations::Resq::MANUAL_URL
    ]

    message = Decouplio::Const::Validations::Resq::VALIDATION_ERROR_MESSAGE % interpolation_values

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::ResqErrorClassError,
                    message: message
  end

  context 'when palp' do
    let(:action_block) { when_does_not_allow_action_option_for_palp }

    interpolation_values = [
      '"palp" does not allow any options',
      Decouplio::Const::Validations::Palp::MANUAL_URL
    ]
    message = Decouplio::Const::Validations::Palp::VALIDATION_ERROR_MESSAGE % interpolation_values

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::PalpValidationError,
                    message: message
  end
end
