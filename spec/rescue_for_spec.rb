# frozen_string_literal: true

RSpec.describe 'Decouplio::Action rescue_for specs' do
  describe '#call' do
    subject(:action) { dummy_instance.call(input_params) }

    let(:error_message) { 'Error message' }

    let(:dummy_instance) do
      Class.new(Decouplio::Action, &action_block)
    end

    let(:string_param) { '4' }
    let(:integer_param) { 4 }
    let(:input_params) do
      {
        string_param: string_param,
        integer_param: integer_param
      }
    end

    context 'rescue blocks' do
      shared_examples 'fails with error' do
        it 'fails' do
          expect(action).to be_failure
        end

        it 'sets errors' do
          expect(action.errors).not_to be_empty
          expect(action.errors).to match expected_errors
        end
      end

      let(:error_to_raise) { StandardError }
      let(:expected_errors) { { step_one_error: [error_message] } }

      before do
        allow(StubRaiseError).to receive(:call)
          .and_raise(error_to_raise, error_message)
      end

      context 'rescue for StandardError' do
        let(:action_block) { step_rescue_single_error_class }

        it_behaves_like 'fails with error'
      end

      context 'rescue for several errors' do
        let(:action_block) { step_rescue_several_error_classes }

        context 'StandardError' do
          it_behaves_like 'fails with error'
        end

        context 'ArgumentError' do
          let(:error_to_raise) { ArgumentError }

          it_behaves_like 'fails with error'
        end
      end

      context 'rescue for several handler methods' do
        let(:action_block) { step_rescue_several_handler_methods }

        context 'StandardError' do
          it_behaves_like 'fails with error'
        end

        context 'ArgumentError' do
          let(:error_to_raise) { ArgumentError }

          it_behaves_like 'fails with error'
        end

        context 'NoMethodError' do
          let(:error_to_raise) { NoMethodError }
          let(:expected_errors) { { another_error: [error_message] } }

          it_behaves_like 'fails with error'
        end
      end

      context 'when handler method is underfined' do
        let(:action_block) { step_rescue_undefined_handler_method }
        let(:error_to_raise) { NoMethodError }
        let(:expected_message) { 'Please define another_error_handler method' }

        it 'raises UndefinedHandlerMethod' do
          expect { action }.to raise_error(
            Decouplio::UndefinedHandlerMethod, expected_message
          )
        end
      end

      context 'rescue should be defined after step or wrapper or iterator' do
        let(:action_block) { rescue_for_without_step }
        let(:expected_message) do
          'rescue_for should be defined after step or wrapper or iterator'
        end

        it 'raises NoStepError' do
          expect { action }.to raise_error(
            Decouplio::NoStepError, expected_message
          )
        end
      end
    end
  end
end
