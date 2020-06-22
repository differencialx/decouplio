# frozen_string_literal: true

RSpec.describe 'Decouplio::Action railway specs' do
  describe '#call' do
    describe 'railway' do
      let(:action_block) { railway }

      let(:params) do
        { param1: param1, param2: param2 }
      end
      let(:param1) { 'param1' }
      let(:param2) { 'param2' }
      let(:railway_flow) { %i[model check_param1 param2 param2_present? update_param2 result_step action1 action3] }

      it 'success' do
        expect(action).to be_success
        expect(action.railway_flow).to eq railway_flow
        expect(action[:param2]).to eq 'updated_param2'
        expect(action[:action1]).to eq true
        expect(action[:action3]).to eq true
        expect(action[:action2]).to be_nil
      end

      context 'with param1 errors' do
        let(:param1) { nil }
        let(:expected_errors) { { base: ['Invalid inner_action_param'] } }
        let(:railway_flow) { %i[model check_param1 param1_error] }

        it 'sets error' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq railway_flow
          expect(action.errors).to match expected_errors
        end
      end

      context 'with nil param2' do
        let(:param2) { nil }
        let(:railway_flow) { %i[model check_param1 param2 param2_present? result_step second_action] }

        it 'success' do
          expect(action).to be_success
          expect(action.railway_flow).to eq railway_flow
          expect(action[:param2]).to be_nil
          expect(action[:action2]).to eq true
          expect(action[:action1]).to be_nil
          expect(action[:action3]).to be_nil
        end
      end
    end
  end
end
