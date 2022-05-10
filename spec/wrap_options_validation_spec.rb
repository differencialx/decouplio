# frozen_string_literal: true

RSpec.describe 'Wrap options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when wrap on_success step is not defined' do
      let(:action_block) { when_wrap_on_success_step_not_defined }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:on_success=>:step_two}',
        'Step "step_two" is not defined',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]

      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepIsNotDefinedForWrapError,
                      message: message
    end

    context 'when wrap on_failure step is not defined' do
      let(:action_block) { when_wrap_on_failure_step_not_defined }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:on_failure=>:step_two}',
        'Step "step_two" is not defined',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]

      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepIsNotDefinedForWrapError,
                      message: message
    end

    context 'when wrap on_success step is not defined after wrap' do
      let(:action_block) { when_wrap_on_success_step_is_not_defined }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:on_success=>:step_three}',
        'Step "step_three" is not defined',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]

      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepIsNotDefinedForWrapError,
                      message: message
    end

    context 'when wrap on_failure step is not defined after wrap' do
      let(:action_block) { when_wrap_on_failure_step_is_not_defined }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:on_failure=>:step_three}',
        'Step "step_three" is not defined',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]

      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepIsNotDefinedForWrapError,
                      message: message
    end

    context 'when wrap finish_him is not a boolean' do
      let(:action_block) { when_wrap_finish_him_is_not_a_boolean }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:finish_him=>123}',
        '"finish_him" does not allow "123" value',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::WrapFinishHimError,
                      message: message
    end

    context 'when wrap finish_him is a boolean' do
      let(:action_block) { when_wrap_finish_him_is_a_boolean }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:finish_him=>true}',
        '"finish_him" does not allow "true" value',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::WrapFinishHimError,
                      message: message
    end

    context 'when wrap finish_him is not :on_success nor :on_failure' do
      let(:action_block) { when_wrap_finish_him_is_not_a_on_success_or_on_failure_symbol }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:finish_him=>:some_option}',
        '"finish_him" does not allow "some_option" value',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::WrapFinishHimError,
                      message: message
    end

    context 'when not allowed option is provided for wrap' do
      let(:action_block) { when_wrap_not_allowed_option_provided }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:not_allowed_option=>:some_option}',
        'Please check if wrap option is allowed',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::ExtraKeyForWrapError,
                      message: message
    end

    context 'when wrap klass is present and method was not passed' do
      let(:action_block) { when_wrap_klass_is_present_and_method_was_not_passed }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:klass=>ClassWithWrapperMethod}',
        '"klass" options should be passed along with "method" option',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::WrapKlassMethodError,
                      message: message
    end

    context 'when wrap method is present and klass was not passed' do
      let(:action_block) { when_wrap_method_is_present_and_klass_was_not_passed }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:method=>:turonsakteon}',
        '"klass" options should be passed along with "method" option',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::WrapKlassMethodError,
                      message: message
    end

    context 'when wrap name is not specified' do
      let(:action_block) { when_wrap_name_is_not_specified }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        'wrap name is empty',
        'Please specify name for "wrap"',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::InvalidWrapNameError,
                      message: message
    end

    context 'when wrap on_success and finish_him present' do
      let(:action_block) { when_wrap_on_success_and_finish_him_present }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:on_success=>:step_two, :finish_him=>:on_failure}',
        '"on_success" option(s) is not allowed along with "finish_him" option(s)',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::WrapControversialKeysError,
                      message: message
    end

    context 'when wrap on_failure and finish_him present' do
      let(:action_block) { when_wrap_on_failure_and_finish_him_present }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:on_failure=>:step_two, :finish_him=>:on_success}',
        '"on_failure" option(s) is not allowed along with "finish_him" option(s)',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::WrapControversialKeysError,
                      message: message
    end

    context 'when wrap if and unless present' do
      let(:action_block) { when_wrap_if_and_unless_is_present }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:if=>:some_condition?, :unless=>:condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::WrapControversialKeysError,
                      message: message
    end

    context 'when wrap on_success/if/unless present' do
      let(:action_block) { when_wrap_on_success_if_and_unless_is_present }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:if=>:some_condition?, :unless=>:some_condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::WrapControversialKeysError,
                      message: message
    end

    context 'when wrap on_failure/if/unless present' do
      let(:action_block) { when_wrap_on_failure_if_and_unless_is_present }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:if=>:some_condition?, :unless=>:some_condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::WrapControversialKeysError,
                      message: message
    end

    context 'when wrap finish_him/if/unless present' do
      let(:action_block) { when_wrap_finish_him_if_and_unless_is_present }

      interpolation_values = [
        Decouplio::Const::Colors::YELLOW,
        '{:if=>:some_condition?, :unless=>:some_condition?}',
        '"if" option(s) is not allowed along with "unless" option(s)',
        Decouplio::Const::Validations::Wrap::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Wrap::MANUAL_URL,
        Decouplio::Const::Colors::NO_COLOR
      ]
      message = Decouplio::Const::Validations::Wrap::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::WrapControversialKeysError,
                      message: message
    end
  end
end
