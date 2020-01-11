# frozen_string_literal: true

RSpec.describe Decouplio::Action do
  context '#call' do
    let(:error_message) { 'Error message' }
    subject(:action) { dummy_instance.call(input_params) }

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

    context 'validations' do
      let(:action_block) { validations }
      let(:string_param) { false }
      let(:expected_errors) { { string_param: ['must be a string'] } }

      it 'sets errors' do
        expect(action.errors).not_to be_empty
        expect(action.errors).to match expected_errors
      end

      it 'fails' do
        expect(action).to be_failure
      end
    end

    context 'custom validations' do
      let(:action_block) { custom_validations }
      let(:string_param) { '3' }
      let(:expected_errors) { { invalid_string_param: ['Invalid string param'] } }

      it 'sets errors' do
        expect(action.errors).not_to be_empty
        expect(action.errors).to match expected_errors
      end

      it 'fails' do
        expect(action).to be_failure
      end
    end

    context 'steps' do
      let(:action_block) { steps }
      let(:expected_result) { string_param }

      it 'success' do
        expect(action).to be_success
      end

      it 'sets result' do
        expect(action[:result]).to eq expected_result
      end
    end

    context 'nested steps' do
      let(:action_block) { inner_action }
      let(:input_params) do
        {
          integer_param: integer_param,
          inner_action_param: inner_action_param
        }
      end
      let(:inner_action_param) { 42 }
      let(:expected_result) { 80 }

      context 'success' do
        it 'success' do
          expect(action).to be_success
        end

        it 'sets result' do
          expect(action[:result]).to eq expected_result
        end
      end

      context 'failure' do
        let(:inner_action_param) { 41 }
        let(:expected_errors) { { invalid_inner_action_param: ['Invalid inner_action_param'] } }

        it 'fails' do
          expect(action).to be_failure
        end

        it 'sets errors to parent action' do
          expect(action.errors).not_to be_empty
          expect(action.errors).to match expected_errors
        end
      end
    end

    context 'wrappers' do
      class ClassWithWrapperMethod
        def self.transaction(&block)
          block.call
        end
      end
      class ClassWithWrapperMethodError < StandardError; end

      let(:action_block) { wrappers }

      context 'success' do
        it 'success' do
          expect(action).to be_success
        end

        it 'result eq ' do
          expect(action[:result]).to eq 16
        end
      end

      context 'failure' do
        let(:error_message) { 'Error messages' }
        let(:expected_errors) { { wrapper_error: [error_message] } }

        before do
          allow(ClassWithWrapperMethod).to receive(:transaction)
            .and_raise(ClassWithWrapperMethodError, error_message)
        end

        it 'fails' do
          expect(action).to be_failure
        end

        it 'sets errors' do
          expect(action.errors).not_to be_empty
          expect(action.errors).to match expected_errors
        end
      end
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

      context 'rescue for underfined handler method' do
        let(:action_block) { step_rescue_undefined_handler_method }
        let(:error_to_raise) { NoMethodError }

        it 'raises UndefinedHandlerMethod' do
          expect{ action }.to raise_error(Decouplio::UndefinedHandlerMethod, 'Please define another_error_handler method')
        end
      end

      context 'rescue should be defined after step or wrapper or iterator' do
        let(:action_block) { rescue_for_without_step }
        context 'NoStepError' do
          it 'raises NoStepError' do
            expect{ action }.to raise_error(Decouplio::NoStepError, 'rescue_for should be defined after step or wrapper or iterator')
          end
        end
      end
    end
  end
end
