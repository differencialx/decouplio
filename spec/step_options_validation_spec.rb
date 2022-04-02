RSpec.describe 'Step options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when on_success step method is not defined' do
      let(:action_block) { when_step_on_success_step_method_not_defined }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:on_success=>:step_two}',
        'Method "step_two" is not defined',
        Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STEP_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]

      message = Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when on_failure step method is not defined' do
      let(:action_block) { when_step_on_failure_step_method_not_defined }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:on_failure=>:step_two}',
        'Method "step_two" is not defined',
        Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STEP_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when on_success step is not defined' do
      let(:action_block) { when_step_on_success_step_not_defined }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:on_success=>:step_two}',
        'Step "step_two" is not defined',
        Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STEP_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]

      message = Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when on_failure step is not defined' do
      let(:action_block) { when_step_on_failure_step_not_defined }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:on_failure=>:step_two}',
        'Step "step_two" is not defined',
        Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STEP_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]

      message = Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when step finish_him is not a boolean' do
      let(:action_block) { when_step_finish_him_is_not_a_boolean }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:finish_him=>123}',
        '"finish_him" does not allow "123" value',
        Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STEP_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when step finish_him is a boolean' do
      let(:action_block) { when_step_finish_him_is_a_boolean }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:finish_him=>true}',
        '"finish_him" does not allow "true" value',
        Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STEP_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when step finish_him is not :on_success nor :on_failure' do
      let(:action_block) { when_step_finish_him_is_not_a_on_success_or_on_failure_symbol }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:finish_him=>:some_step}',
        '"finish_him" does not allow "some_step" value',
        Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STEP_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when not allowed option is provided for step' do
      let(:action_block) { when_step_not_allowed_option_provided }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:not_allowed_option=>:some_option}',
        'Please check if step option is allowed',
        Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STEP_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when if method is not defined' do
      let(:action_block) { when_step_if_method_is_not_defined }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:if=>:some_undefined_method}',
        'Method "some_undefined_method" is not defined',
        Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STEP_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when unless method is not defined' do
      let(:action_block) { when_step_unless_method_is_not_defined }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:unless=>:some_undefined_method}',
        'Method "some_undefined_method" is not defined',
        Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STEP_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when step method is not defined' do
      let(:action_block) { when_step_method_is_not_defined }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        'step :step_one',
        'Method "step_one" is not defined',
        Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STEP_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end
  end
end
