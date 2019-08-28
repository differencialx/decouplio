# frozen_string_literal: true

RSpec.describe Decouplio::Action do
  context 'steps' do
    let(:error_message) { 'Error message' }
    subject(:action) { dummy_class.(input_params) }

    let(:dummy_class) do
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
  end
end
