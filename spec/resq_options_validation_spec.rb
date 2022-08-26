# frozen_string_literal: true

RSpec.describe 'Resq options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when resq handler method is not a symbol' do
      let(:action_block) { when_resq_handler_method_is_not_a_symbol }

      interpolation_values = [
        '"Not a symbol" is not allowed as a handler method for "resq"',
        'Handler method should be a symbol',
        Decouplio::Const::Validations::Resq::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Resq::MANUAL_URL
      ]

      message = Decouplio::Const::Validations::Resq::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::ResqHandlerMethodError,
                      message: message
    end

    context 'when resq error class is not inherited from exception' do
      let(:action_block) { when_resq_error_class_is_not_inherited_from_exception }

      interpolation_values = [
        '"StubDummy" class is not allowed for "resq"',
        'Please use exception class. StubDummy does not inherited from Exception class',
        Decouplio::Const::Validations::Resq::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Resq::MANUAL_URL
      ]

      message = Decouplio::Const::Validations::Resq::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::InvalidErrorClassError,
                      message: message
    end

    context 'when resq error classes is not inherited from exception' do
      let(:action_block) { when_resq_error_classes_is_not_inherited_from_exception }

      interpolation_values = [
        '"StubDummy" class is not allowed for "resq"',
        'Please use exception class. StubDummy does not inherited from Exception class',
        Decouplio::Const::Validations::Resq::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Resq::MANUAL_URL
      ]

      message = Decouplio::Const::Validations::Resq::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::InvalidErrorClassError,
                      message: message
    end

    context 'when resq error classes is not a class or array' do
      let(:action_block) { when_resq_error_class_is_not_a_class_or_array }

      interpolation_values = [
        'Invalid handler class value "{:key=>"val"}"',
        'Please specify exception class(es) for "handle_error"',
        Decouplio::Const::Validations::Resq::ALLOWED_OPTIONS_MESSAGE,
        Decouplio::Const::Validations::Resq::MANUAL_URL
      ]

      message = Decouplio::Const::Validations::Resq::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::ResqErrorClassError,
                      message: message
    end

    context 'when resq options are invalid' do
      let(:action_block) { when_resq_options_are_invalid }

      interpolation_values = [
        'resq -->SOme handler method<--, -->{}<--',
        Decouplio::Const::Validations::Resq::MANUAL_URL
      ]

      message = Decouplio::Const::Validations::Resq::OPTIONS_DEFINITION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::InvalidOptionsForResqStep,
                      message: message
    end
  end
end
