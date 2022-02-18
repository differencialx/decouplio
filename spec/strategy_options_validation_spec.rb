RSpec.describe 'Strategy options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when not allowed option is provided for strategy' do
      let(:action_block) { when_strategy_not_allowed_option_provided }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:not_allowed_option=>:some_option}',
        '"not_allowed_option" option(s) is not allowed for "strg"',
        Decouplio::OptionsValidator::STRATEGY_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STRATEGY_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::STRATEGY_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when if method is not defined' do
      let(:action_block) { when_strategy_if_method_is_not_defined }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:if=>:some_undefined_method}',
        'Method "some_undefined_method" is not defined',
        Decouplio::OptionsValidator::STRATEGY_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STRATEGY_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::STRATEGY_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when unless method is not defined' do
      let(:action_block) { when_strategy_unless_method_is_not_defined }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:unless=>:some_undefined_method}',
        'Method "some_undefined_method" is not defined',
        Decouplio::OptionsValidator::STRATEGY_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STRATEGY_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::STRATEGY_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when requred options were not passed' do
      let(:action_block) { when_strategy_required_keys_were_not_passed }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        'Next option(s) "ctx_key" are required for "strg"',
        Decouplio::OptionsValidator::STRATEGY_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::STRATEGY_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]
      message = Decouplio::OptionsValidator::STRATEGY_REQUIRED_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end
  end
end
