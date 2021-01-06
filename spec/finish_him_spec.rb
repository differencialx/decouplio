# frozen_string_literal: true

RSpec.describe 'Decouplio::Action finish_him' do
  include_context 'with basic spec setup'

  describe '#call' do
    let(:input_params) do
      { param1: param1, param2: param2 }
    end
    let(:param1) { 'param1' }
    let(:param2) { nil }

    describe 'finish_him_on_success' do
      let(:action_block) { finish_him_on_success }
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

    describe 'finish_him_on_failure' do
      let(:action_block) { finish_him_on_failure }
      let(:railway_flow) { %i[step_one step_two] }

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

    describe 'finish_him_anyway' do
      let(:action_block) { finish_him_anyway }
      let(:railway_flow) { %i[step_one step_two] }

      context 'param2 true' do
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

      context 'param2 false' do
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
