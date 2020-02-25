# frozen_string_literal: true

RSpec.describe 'Decouplio::Action wrapper specs' do
  describe '#call' do
    include_context 'with basic spec setup'

    let(:action_block) { wrappers }

    context 'when wrapper success' do
      it 'success' do
        expect(action).to be_success
      end

      it 'result eq ' do
        expect(action[:result]).to eq 16
      end
    end

    context 'when wrapper fails' do
      let(:error_message) { 'Error messages' }
      let(:expected_errors) { { wrapper_error: [error_message] } }

      before do
        allow(ClassWithWrapperMethod).to receive(:transaction)
          .and_raise(ClassWithWrapperMethodError, error_message)
      end

      it_behaves_like 'fails with error'
    end

    context 'simple wrapper' do
      before do
        allow(StubRaiseError).to receive(:call)
          .and_raise(ArgumentError, error_message)
      end
      let(:action_block) { simple_wrapper }
      let(:error_message) { 'Error messages' }
      let(:expected_errors) { { wrapper_error: [error_message] } }

      it_behaves_like 'fails with error'

      it 'calls step_one' do
        expect(action[:step_one]).to eq 'Success'
      end

      it 'calls step_two' do
        expect(action[:step_two]).to eq 'Success'
      end

      it 'calls wrapper_step_one' do
        expect(action[:wrapper_step_one]).to eq 'Success'
      end
    end
  end
end
