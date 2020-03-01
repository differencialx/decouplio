# frozen_string_literal: true

RSpec.describe 'Decouplio::Action steps specs' do
  describe '#call' do
    include_context 'with basic spec setup'

    describe 'steps' do
      let(:action_block) { steps }
      let(:expected_result) { string_param }

      it 'success' do
        expect(action).to be_success
      end

      it 'sets result' do
        expect(action[:result]).to eq expected_result
      end
    end

    describe 'empty steps' do
      let(:action_block) { empty_steps }

      it 'raises NoStepError' do
        expect { action }.to raise_error(Decouplio::Errors::NoStepError)
      end
    end
  end
end
