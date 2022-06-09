# frozen_string_literal: true

RSpec.describe '.call! method' do
  include_context 'with basic spec setup'

  let(:input_params) do
    {
      param1: param1
    }
  end
  let(:param1) { nil }

  describe '.call!' do
    let(:action_block) { success_way }
    let(:param1) { false }

    it 'raises an error' do
      expect { action! }.to raise_error(
        Decouplio::Errors::ExecutionError,
        'Action failed.'
      )
    end

    it 'error object contains action' do
      action!
    rescue Decouplio::Errors::ExecutionError => error
      expect(error.action).to be_a(Decouplio::Action)
      expect(error.action).to be_failure
      expect(error.action[:model]).to eq false
      expect(error.action[:result]).to be_nil
      expect(error.message).to eq 'Action failed.'
    end
  end
end
