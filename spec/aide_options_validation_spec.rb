# frozen_string_literal: true

RSpec.describe 'Aide options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when aide finish_him is not a boolean' do
      let(:action_block) { when_aide_finish_him_is_not_a_boolean }

      interpolation_values = [
        '{:finish_him=>123}',
        '"finish_him" does not allow "123" value',
        Decouplio::Const::Validations::Aide::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Aide::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Aide::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::AideFinishHimError,
                      message: message
    end

    context 'when aide finish_him is a boolean' do
      let(:action_block) { when_aide_finish_him_is_a_boolean }

      it_behaves_like 'does not raise any error'
    end

    context 'when aide finish_him is some custom symbol' do
      let(:action_block) { when_aide_finish_him_is_some_custom_symbol }

      interpolation_values = [
        '{:finish_him=>:some_step}',
        '"finish_him" does not allow "some_step" value',
        Decouplio::Const::Validations::Aide::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Aide::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Aide::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::AideFinishHimError,
                      message: message
    end

    context 'when aide on_success and finish_him present' do
      let(:action_block) { when_aide_on_success_and_finish_him_present }

      interpolation_values = [
        '{:on_success=>:step_two, :finish_him=>:on_failure}',
        '"on_success" option(s) is not allowed along with "finish_him" option(s)',
        Decouplio::Const::Validations::Aide::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Aide::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Aide::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::AideControversialKeysError,
                      message: message
    end

    context 'when aide on_failure and finish_him present' do
      let(:action_block) { when_aide_on_failure_and_finish_him_present }

      interpolation_values = [
        '{:on_failure=>:step_two, :finish_him=>:on_success}',
        '"on_failure" option(s) is not allowed along with "finish_him" option(s)',
        Decouplio::Const::Validations::Aide::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Aide::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Aide::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::AideControversialKeysError,
                      message: message
    end

    context 'when aide if and unless present' do
      let(:action_block) { when_aide_if_and_unless_is_present }

      interpolation_values = [
        '{:if=>:some_condition?, :unless=>:condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Aide::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Aide::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Aide::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::AideControversialKeysError,
                      message: message
    end

    context 'when aide on_success/if/unless present' do
      let(:action_block) { when_aide_on_success_if_and_unless_is_present }

      interpolation_values = [
        '{:if=>:some_condition?, :unless=>:some_condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Aide::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Aide::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Aide::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::AideControversialKeysError,
                      message: message
    end

    context 'when aide on_failure/if/unless present' do
      let(:action_block) { when_aide_on_failure_if_and_unless_is_present }

      interpolation_values = [
        '{:if=>:some_condition?, :unless=>:some_condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Aide::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Aide::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Aide::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::AideControversialKeysError,
                      message: message
    end

    context 'when aide finish_him/if/unless present' do
      let(:action_block) { when_aide_finish_him_if_and_unless_is_present }

      interpolation_values = [
        '{:if=>:some_condition?, :unless=>:some_condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Aide::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Aide::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Aide::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::AideControversialKeysError,
                      message: message
    end

    context 'when aide on_success is not defined after fail step' do
      let(:action_block) { when_aide_on_success_step_is_not_defined }

      interpolation_values = [
        '{:on_success=>:step_one}',
        'Step "step_one" is not defined',
        Decouplio::Const::Validations::Aide::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Aide::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Aide::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepIsNotDefinedForAideError,
                      message: message
    end

    context 'when aide on_failure is not defined after fail step' do
      let(:action_block) { when_aide_on_failure_step_is_not_defined }

      interpolation_values = [
        '{:on_failure=>:step_one}',
        'Step "step_one" is not defined',
        Decouplio::Const::Validations::Aide::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Aide::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Aide::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepIsNotDefinedForAideError,
                      message: message
    end
  end
end
