# frozen_string_literal: true

RSpec.describe 'Fail options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when fail finish_him is not a boolean' do
      let(:action_block) { when_fail_finish_him_is_not_a_boolean }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:finish_him=>123}',
        '"finish_him" does not allow "123" value',
        Decouplio::Const::Validations::Fail::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Fail::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Fail::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::FailFinishHimError,
                      message: message
    end

    context 'when step finish_him is a boolean' do
      let(:action_block) { when_fail_finish_him_is_a_boolean }

      it_behaves_like 'does not raise any error'
    end

    context 'when step finish_him is some custom symbol' do
      let(:action_block) { when_fail_finish_him_is_some_custom_symbol }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:finish_him=>:some_step}',
        '"finish_him" does not allow "some_step" value',
        Decouplio::Const::Validations::Fail::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Fail::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Fail::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::FailFinishHimError,
                      message: message
    end

    context 'when not allowed option is provided for step' do
      let(:action_block) { when_fail_not_allowed_option_provided }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:not_allowed_option=>:some_option}',
        '"not_allowed_option" option(s) is not allowed for "fail"',
        Decouplio::Const::Validations::Fail::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Fail::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Fail::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::ExtraKeyForFailError,
                      message: message
    end

    context 'when fail on_success and finish_him present' do
      let(:action_block) { when_fail_on_success_and_finish_him_present }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:on_success=>:step_two, :finish_him=>:on_failure}',
        '"on_success" option(s) is not allowed along with "finish_him" option(s)',
        Decouplio::Const::Validations::Fail::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Fail::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Fail::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::FailControversialKeysError,
                      message: message
    end

    context 'when fail on_failure and finish_him present' do
      let(:action_block) { when_fail_on_failure_and_finish_him_present }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:on_failure=>:step_two, :finish_him=>:on_success}',
        '"on_failure" option(s) is not allowed along with "finish_him" option(s)',
        Decouplio::Const::Validations::Fail::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Fail::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Fail::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::FailControversialKeysError,
                      message: message
    end

    context 'when fail if and unless present' do
      let(:action_block) { when_fail_if_and_unless_is_present }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:if=>:some_condition?, :unless=>:some_condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Fail::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Fail::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Fail::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::FailControversialKeysError,
                      message: message
    end

    context 'when fail on_success/if/unless present' do
      let(:action_block) { when_fail_on_success_if_and_unless_is_present }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:if=>:some_condition?, :unless=>:some_condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Fail::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Fail::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Fail::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::FailControversialKeysError,
                      message: message
    end

    context 'when fail on_failure/if/unless present' do
      let(:action_block) { when_fail_on_failure_if_and_unless_is_present }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:if=>:some_condition?, :unless=>:some_condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Fail::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Fail::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Fail::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::FailControversialKeysError,
                      message: message
    end

    context 'when fail finish_him/if/unless present' do
      let(:action_block) { when_fail_finish_him_if_and_unless_is_present }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:if=>:some_condition?, :unless=>:some_condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Fail::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Fail::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Fail::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::FailControversialKeysError,
                      message: message
    end
  end
end
