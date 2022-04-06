# frozen_string_literal: true

RSpec.describe 'Pass options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when on_success is not allowed' do
      let(:action_block) { when_pass_on_succes_is_not_allowed }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:on_success=>:step_one}',
        '"on_success" option(s) is not allowed for "pass"',
        Decouplio::OptionsValidator::PASS_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::PASS_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]

      message = Decouplio::OptionsValidator::PASS_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when on_failure is not allowed' do
      let(:action_block) { when_pass_on_failure_is_not_allowed }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:on_failure=>:step_one}',
        '"on_failure" option(s) is not allowed for "pass"',
        Decouplio::OptionsValidator::PASS_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::PASS_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]

      message = Decouplio::OptionsValidator::PASS_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when pass finish_him is not a boolean' do
      let(:action_block) { when_pass_finish_him_is_not_a_boolean }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:finish_him=>123}',
        '"finish_him" does not allow "123" value',
        Decouplio::OptionsValidator::PASS_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::PASS_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::PASS_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when pass finish_him is a boolean' do
      let(:action_block) { when_pass_finish_him_is_a_boolean }

      it_behaves_like 'does not raise any error'
    end

    context 'when step finish_him is some custom symbol' do
      let(:action_block) { when_pass_finish_him_is_some_custom_symbol }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:finish_him=>:some_step}',
        '"finish_him" does not allow "some_step" value',
        Decouplio::OptionsValidator::PASS_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::PASS_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::PASS_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when finish_him is on_success symbol' do
      let(:action_block) { when_pass_finish_him_is_on_success_symbol }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:finish_him=>:on_success}',
        '"finish_him" does not allow "on_success" value',
        Decouplio::OptionsValidator::PASS_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::PASS_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::PASS_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when finish_him is on_failure symbol' do
      let(:action_block) { when_pass_finish_him_is_on_failure_symbol }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:finish_him=>:on_failure}',
        '"finish_him" does not allow "on_failure" value',
        Decouplio::OptionsValidator::PASS_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::PASS_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::PASS_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when if method is not defined' do
      let(:action_block) { when_pass_if_method_is_not_defined }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:if=>:some_undefined_method}',
        'Method "some_undefined_method" is not defined',
        Decouplio::OptionsValidator::PASS_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::PASS_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::PASS_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when unless method is not defined' do
      let(:action_block) { when_pass_unless_method_is_not_defined }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:unless=>:some_undefined_method}',
        'Method "some_undefined_method" is not defined',
        Decouplio::OptionsValidator::PASS_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::PASS_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::PASS_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when not allowed option is provided for step' do
      let(:action_block) { when_pass_not_allowed_option_provided }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:not_allowed_option=>:some_option}',
        '"not_allowed_option" option(s) is not allowed for "pass"',
        Decouplio::OptionsValidator::PASS_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::PASS_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::PASS_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when pass method is not defined' do
      let(:action_block) { when_pass_method_is_not_defined }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        'pass :step_two',
        'Method "step_two" is not defined',
        Decouplio::OptionsValidator::PASS_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::PASS_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::PASS_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end
  end
end
