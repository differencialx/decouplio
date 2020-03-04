# frozen_string_literal: true

RSpec.describe 'Decouplio::Action after block cases' do
  describe '#call' do
    include_context 'with after block setup'
    let(:after_block) do
      lambda do |outcome|
        @success = outcome.success? ? 'Success' : 'Failure'
        outcome
      end
    end

    describe 'steps' do
      context 'when success' do
        let(:action_block) { after_block_success }

        it 'sets instance variable @success inside rspec context' do
          action
          expect(@success).to eq 'Success'
        end

        it 'success' do
          expect(action).to be_success
        end
      end

      context 'when fails' do
        before do
          allow(StubDummy).to receive(:call)
            .and_raise(StandardError)
        end

        let(:action_block) { after_block_fail }

        it 'sets instance variable @success inside rspec context' do
          action
          expect(@success).to eq 'Failure'
        end

        it 'fails' do
          expect(action).to be_failure
        end
      end
    end
  end
end
