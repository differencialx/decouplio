# frozen_string_literal: true

RSpec.describe 'Pass options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when on_success is not allowed' do
      let(:action_block) { when_pass_on_succes_is_not_allowed }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:on_success=>:step_one}',
        '"on_success" option(s) is not allowed for "pass"',
        Decouplio::Const::Validations::Pass::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Pass::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]

      message = Decouplio::Const::Validations::Pass::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::ExtraKeyForPassError,
                      message: message
    end

    context 'when on_failure is not allowed' do
      let(:action_block) { when_pass_on_failure_is_not_allowed }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:on_failure=>:step_one}',
        '"on_failure" option(s) is not allowed for "pass"',
        Decouplio::Const::Validations::Pass::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Pass::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]

      message = Decouplio::Const::Validations::Pass::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::ExtraKeyForPassError,
                      message: message
    end

    context 'when pass finish_him is not a boolean' do
      let(:action_block) { when_pass_finish_him_is_not_a_boolean }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:finish_him=>123}',
        '"finish_him" does not allow "123" value',
        Decouplio::Const::Validations::Pass::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Pass::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Pass::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::PassFinishHimError,
                      message: message
    end

    context 'when pass finish_him is a boolean' do
      let(:action_block) { when_pass_finish_him_is_a_boolean }

      it_behaves_like 'does not raise any error'
    end

    context 'when step finish_him is some custom symbol' do
      let(:action_block) { when_pass_finish_him_is_some_custom_symbol }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:finish_him=>:some_step}',
        '"finish_him" does not allow "some_step" value',
        Decouplio::Const::Validations::Pass::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Pass::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Pass::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::PassFinishHimError,
                      message: message
    end

    context 'when finish_him is on_success symbol' do
      let(:action_block) { when_pass_finish_him_is_on_success_symbol }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:finish_him=>:on_success}',
        '"finish_him" does not allow "on_success" value',
        Decouplio::Const::Validations::Pass::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Pass::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Pass::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::PassFinishHimError,
                      message: message
    end

    context 'when finish_him is on_failure symbol' do
      let(:action_block) { when_pass_finish_him_is_on_failure_symbol }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:finish_him=>:on_failure}',
        '"finish_him" does not allow "on_failure" value',
        Decouplio::Const::Validations::Pass::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Pass::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Pass::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::PassFinishHimError,
                      message: message
    end

    context 'when not allowed option is provided for step' do
      let(:action_block) { when_pass_not_allowed_option_provided }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:not_allowed_option=>:some_option}',
        '"not_allowed_option" option(s) is not allowed for "pass"',
        Decouplio::Const::Validations::Pass::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Pass::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Pass::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::ExtraKeyForPassError,
                      message: message
    end
  end
end
