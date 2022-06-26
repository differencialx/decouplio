# frozen_string_literal: true

RSpec.describe 'Step options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when on_success step is not defined' do
      let(:action_block) { when_step_on_success_step_not_defined }

      interpolation_values = [
        '{:on_success=>:step_two}',
        'Step "step_two" is not defined',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]

      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepIsNotDefinedForStepError,
                      message: message
    end

    context 'when on_failure step is not defined' do
      let(:action_block) { when_step_on_failure_step_not_defined }

      interpolation_values = [
        '{:on_failure=>:step_two}',
        'Step "step_two" is not defined',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]

      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepIsNotDefinedForStepError,
                      message: message
    end

    context 'when on_success step is not defined after current step' do
      let(:action_block) { when_step_on_success_step_is_not_defined }

      interpolation_values = [
        '{:on_success=>:step_one}',
        'Step "step_one" is not defined',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]

      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepIsNotDefinedForStepError,
                      message: message
    end

    context 'when on_failure step is not defined after current step' do
      let(:action_block) { when_step_on_failure_step_is_not_defined }

      interpolation_values = [
        '{:on_failure=>:step_one}',
        'Step "step_one" is not defined',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]

      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepIsNotDefinedForStepError,
                      message: message
    end

    context 'when on_error step is not defined after current step' do
      let(:action_block) { when_step_on_error_step_is_not_defined }

      interpolation_values = [
        '{:on_error=>:step_two}',
        'Step "step_two" is not defined',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]

      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepIsNotDefinedForStepError,
                      message: message
    end

    context 'when step finish_him is not a boolean' do
      let(:action_block) { when_step_finish_him_is_not_a_boolean }

      interpolation_values = [
        '{:finish_him=>123}',
        '"finish_him" does not allow "123" value',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepFinishHimError,
                      message: message
    end

    context 'when step finish_him is a boolean' do
      let(:action_block) { when_step_finish_him_is_a_boolean }

      interpolation_values = [
        '{:finish_him=>true}',
        '"finish_him" does not allow "true" value',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepFinishHimError,
                      message: message
    end

    context 'when step finish_him is not :on_success nor :on_failure' do
      let(:action_block) { when_step_finish_him_is_not_a_on_success_or_on_failure_symbol }

      interpolation_values = [
        '{:finish_him=>:some_step}',
        '"finish_him" does not allow "some_step" value',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepFinishHimError,
                      message: message
    end

    context 'when not allowed option is provided for step' do
      let(:action_block) { when_step_not_allowed_option_provided }

      interpolation_values = [
        '{:not_allowed_option=>:some_option}',
        'Please check if step option is allowed',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::ExtraKeyForStepError,
                      message: message
    end

    context 'when step on_success and finish_him present' do
      let(:action_block) { when_step_on_success_and_finish_him_present }

      interpolation_values = [
        '{:on_success=>:step_two, :finish_him=>:on_failure}',
        '"on_success" option(s) is not allowed along with "finish_him" option(s)',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepControversialKeysError,
                      message: message
    end

    context 'when step on_failure and finish_him present' do
      let(:action_block) { when_step_on_failure_and_finish_him_present }

      interpolation_values = [
        '{:on_failure=>:step_two, :finish_him=>:on_success}',
        '"on_failure" option(s) is not allowed along with "finish_him" option(s)',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepControversialKeysError,
                      message: message
    end

    context 'when step if and unless present' do
      let(:action_block) { when_step_if_and_unless_is_present }

      interpolation_values = [
        '{:if=>:some_condition?, :unless=>:condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepControversialKeysError,
                      message: message
    end

    context 'when step on_success/if/unless present' do
      let(:action_block) { when_step_on_success_if_and_unless_is_present }

      interpolation_values = [
        '{:if=>:some_condition?, :unless=>:some_condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepControversialKeysError,
                      message: message
    end

    context 'when step on_failure/if/unless present' do
      let(:action_block) { when_step_on_failure_if_and_unless_is_present }

      interpolation_values = [
        '{:if=>:some_condition?, :unless=>:some_condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepControversialKeysError,
                      message: message
    end

    context 'when step finish_him/if/unless present' do
      let(:action_block) { when_step_finish_him_if_and_unless_is_present }

      interpolation_values = [
        '{:if=>:some_condition?, :unless=>:some_condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL
      ]
      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepControversialKeysError,
                      message: message
    end
  end
end
