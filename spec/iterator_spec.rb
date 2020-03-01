# frozen_string_literal: true

RSpec.describe 'Decouplio::Action iterator specs' do
  describe '#call' do
    include_context 'with basic spec setup'
    include_context 'with input params'

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
  end
end
