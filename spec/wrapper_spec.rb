# frozen_string_literal: true

RSpec.describe 'Decouplio::Action wrapper specs' do
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
