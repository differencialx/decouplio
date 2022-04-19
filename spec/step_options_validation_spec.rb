# frozen_string_literal: true

RSpec.describe 'Step options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when on_success step is not defined' do
      let(:action_block) { when_step_on_success_step_not_defined }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:on_success=>:step_two}',
        'Step "step_two" is not defined',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]

      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepIsNotDefinedError,
                      message: message
    end

    context 'when on_failure step is not defined' do
      let(:action_block) { when_step_on_failure_step_not_defined }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:on_failure=>:step_two}',
        'Step "step_two" is not defined',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]

      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepIsNotDefinedError,
                      message: message
    end

    context 'when step finish_him is not a boolean' do
      let(:action_block) { when_step_finish_him_is_not_a_boolean }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:finish_him=>123}',
        '"finish_him" does not allow "123" value',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepFinishHimError,
                      message: message
    end

    context 'when step finish_him is a boolean' do
      let(:action_block) { when_step_finish_him_is_a_boolean }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:finish_him=>true}',
        '"finish_him" does not allow "true" value',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepFinishHimError,
                      message: message
    end

    context 'when step finish_him is not :on_success nor :on_failure' do
      let(:action_block) { when_step_finish_him_is_not_a_on_success_or_on_failure_symbol }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:finish_him=>:some_step}',
        '"finish_him" does not allow "some_step" value',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepFinishHimError,
                      message: message
    end

    context 'when not allowed option is provided for step' do
      let(:action_block) { when_step_not_allowed_option_provided }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:not_allowed_option=>:some_option}',
        'Please check if step option is allowed',
        Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Step::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::ExtraKeyForStepError,
                      message: message
    end
  end
end
