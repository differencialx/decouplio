# frozen_string_literal: true

RSpec.describe 'Decouplio::Action rescue_for specs' do
  describe '#call' do
    include_context 'with basic spec setup'

    let(:error_to_raise) { StandardError }
    let(:expected_errors) { { step_one_error: [error_message] } }

    before do
      allow(StubRaiseError).to receive(:call)
        .and_raise(error_to_raise, error_message)
    end

    context 'when rescue for handles StandardError' do
      let(:action_block) { step_rescue_single_error_class }

      it_behaves_like 'fails with error'
    end

    context 'when rescue for handles several errors' do
      let(:action_block) { step_rescue_several_error_classes }

      context 'when raises StandardError' do
        it_behaves_like 'fails with error'
      end

      context 'when raises ArgumentError' do
        let(:error_to_raise) { ArgumentError }

        it_behaves_like 'fails with error'
      end
    end

    context 'when rescue for handles several with handler methods' do
      let(:action_block) { step_rescue_several_handler_methods }

      context 'when raises StandardError' do
        it_behaves_like 'fails with error'
      end

      context 'when raises ArgumentError' do
        let(:error_to_raise) { ArgumentError }

        it_behaves_like 'fails with error'
      end

      context 'when raises NoMethodError' do
        let(:error_to_raise) { NoMethodError }
        let(:expected_errors) { { another_error: [error_message] } }

        it_behaves_like 'fails with error'
      end
    end

    context 'when handler method is underfined' do
      let(:action_block) { step_rescue_undefined_handler_method }
      let(:error_to_raise) { NoMethodError }
      let(:expected_message) { 'Please define another_error_handler method' }

      it 'raises UndefinedHandlerMethodError' do
        expect { action }.to raise_error(
          Decouplio::Errors::UndefinedHandlerMethodError, expected_message
        )
      end
    end

    context 'when rescue_for is defined, but step, wrapper or iteration absent' do
      let(:action_block) { rescue_for_without_step }
      let(:expected_message) do
        'rescue_for should be defined after step or wrapper or iterator'
      end

      it 'raises NoStepError' do
        expect { action }.to raise_error(
          Decouplio::Errors::NoStepError, expected_message
        )
      end
    end
  end
end
