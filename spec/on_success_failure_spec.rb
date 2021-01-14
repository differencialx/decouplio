# frozen_string_literal: true

RSpec.describe 'Decouplio::Action on_success on_failure' do
  include_context 'with basic spec setup'

  describe '#call' do
    let(:input_params) do
      { param1: param1, param2: param2 }
    end
    let(:param1) { 'param1' }
    let(:param2) { nil }

    describe 'on_success' do
      context 'when finish_him' do
        let(:action_block) { on_success_finish_him }
        let(:railway_flow) { %i[step_one step_two] }
        let(:param2) { true }

        it 'success' do
          expect(action).to be_success
        end

        it 'sets result as param1' do
          expect(action[:result]).to eq param1
        end

        it 'sets railway flow' do
          expect(action.railway_flow).to eq railway_flow
        end
      end
    end

    describe 'on failure' do
      context 'when finish_him' do
        let(:action_block) { on_failure_finish_him }
        let(:railway_flow) { %i[step_one step_two] }
        let(:param2) { true }

        it 'success' do
          expect(action).to be_failure
        end

        it 'sets result as param1' do
          expect(action[:result]).to eq param1
        end

        it 'sets railway flow' do
          expect(action.railway_flow).to eq railway_flow
        end
      end
    end
  end
end
