# frozen_string_literal: true

RSpec.describe 'Decouplio::Action rescue_for specs' do
  describe '#call' do
    include_context 'with basic spec setup'

    let(:error_to_raise) { StandardError }
    let(:expected_errors) { { step_one_error: [error_message] } }
    let(:action_block) { on_failure }

    context 'when fail step performs' do
      before do
        allow(StubDummy).to receive(:call)
          .and_raise(error_to_raise, error_message)
      end

      it 'context contains fail_step_result' do
        expect(action[:fail_step_result]).to eq 'Failure'
      end
    end

    context 'when fail step does not perform' do
      it 'context contains fail_step_result' do
        expect(action[:fail_step_result]).to be_nil
      end
    end
  end
end
