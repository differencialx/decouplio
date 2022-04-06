RSpec.describe 'Resq options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when resq not allowed option is passed' do
      let(:action_block) { when_resq_not_allowed_option_is_passed }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:on_success=>:pass_step}',
        '"resq" does not allow "{:on_success=>:pass_step}" options',
        Decouplio::OptionsValidator::RESQ_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::RESQ_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]

      message = Decouplio::OptionsValidator::RESQ_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when resq handler method is not a symbol' do
      let(:action_block) { when_resq_handler_method_is_not_a_symbol }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{"Not a symbol"=>[NoMethodError]}',
        'Handler method should be a symbol',
        Decouplio::OptionsValidator::RESQ_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::RESQ_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]

      message = Decouplio::OptionsValidator::RESQ_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when resq error class is not inherited from exception' do
      let(:action_block) { when_resq_error_class_is_not_inherited_from_exception }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:handle_error=>StubDummy}',
        'Please use exception class. [StubDummy] does not inherited from Exception class',
        Decouplio::OptionsValidator::RESQ_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::RESQ_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]

      message = Decouplio::OptionsValidator::RESQ_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when resq error classes is not inherited from exception' do
      let(:action_block) { when_resq_error_classes_is_not_inherited_from_exception }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:handle_error=>[StubDummy, StandardError, String]}',
        'Please use exception class. [StubDummy, String] does not inherited from Exception class',
        Decouplio::OptionsValidator::RESQ_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::RESQ_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]

      message = Decouplio::OptionsValidator::RESQ_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end

    context 'when resq error classes is not inherited from exception' do
      let(:action_block) { when_resq_error_class_is_not_a_class_or_array }

      interpolation_values = [
        Decouplio::OptionsValidator::YELLOW,
        '{:handle_error=>{:key=>"val"}}',
        'Please specify exception class(es) for "handle_error"',
        Decouplio::OptionsValidator::RESQ_ALLOWED_OPTIONS_MESSAGE,
        Decouplio::OptionsValidator::RESQ_MANUAL_URL,
        Decouplio::OptionsValidator::NO_COLOR
      ]

      message = Decouplio::OptionsValidator::RESQ_VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      message: message
    end
  end
end
