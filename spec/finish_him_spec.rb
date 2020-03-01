# frozen_string_literal: true

RSpec.describe 'Decouplio::Action finish him specs' do
  describe '#call' do
    include_context 'with basic spec setup'
    include_context 'with input params'

    describe 'finish him' do
      let(:action_block) { finish_him }
      let(:expected_errors) { { something_wrong: ['Something went wrong'] } }

      it_behaves_like 'fails with error'

      it 'does not set result from step_3' do
        expect(action[:result]).not_to eq 'Done'
      end
    end
  end
end
