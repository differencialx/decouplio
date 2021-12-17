# frozen_string_literal: true

RSpec.describe 'Decouplio::Action on_success on_failure' do
  include_context 'with basic spec setup'

  describe '#call' do
    let(:input_params) do
      {
        param1: param1,
        param2: param2,
        param3: param3,
        param4: param4,
        param5: param5,
        param6: param6,
        param7: param7,
        param8: param8,
        param9: param9,
        custom_param: custom_param
      }
    end
    let(:param1) { 'param1' }
    let(:param2) { nil }
    let(:param3) { nil }
    let(:param4) { nil }
    let(:param5) { 'Five' }
    let(:param6) { 'Six' }
    let(:param7) { 'Seven' }
    let(:param8) { 'Eight' }
    let(:param9) { 'Nine' }
    let(:custom_param) { nil }

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

      context 'when custom step' do
        let(:action_block) { on_success_custom_step }
        let(:param2) { true }

        context 'when custom method moves on success track' do
          let(:railway_flow) { %i[step_one step_two custom_step custom_pass_step] }
          let(:custom_param) { true }

          it 'success' do
            expect(action).to be_success
          end

          it 'sets result as param1' do
            expect(action[:result]).to eq 'Custom pass step'
          end

          it 'sets railway flow' do
            expect(action.railway_flow).to eq railway_flow
          end
        end

        context 'when custom method moves on failure track' do
          let(:railway_flow) { %i[step_one step_two custom_step custom_fail_step] }
          let(:custom_param) { false }

          it 'success' do
            expect(action).to be_failure
          end

          it 'sets result as param1' do
            expect(action[:result]).to eq 'Custom fail step'
          end

          it 'sets railway flow' do
            expect(action.railway_flow).to eq railway_flow
          end
        end
      end
    end

    describe 'on failure' do
      context 'when finish_him' do
        let(:action_block) { on_failure_finish_him }
        let(:railway_flow) { %i[step_one step_two] }
        let(:param2) { false }

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

      context 'when custom step' do
        let(:action_block) { on_failure_custom_step }
        let(:param2) { false }

        context 'when custom method moves on success track' do
          let(:railway_flow) { %i[step_one step_two custom_step custom_pass_step] }
          let(:custom_param) { true }

          it 'success' do
            expect(action).to be_success
          end

          it 'sets result as param1' do
            expect(action[:result]).to eq 'Custom pass step'
          end

          it 'sets railway flow' do
            expect(action.railway_flow).to eq railway_flow
          end
        end

        context 'when custom method moves on failure track' do
          let(:railway_flow) { %i[step_one step_two custom_step custom_fail_step] }
          let(:custom_param) { false }

          it 'success' do
            expect(action).to be_failure
          end

          it 'sets result as param1' do
            expect(action[:result]).to eq 'Custom fail step'
          end

          it 'sets railway flow' do
            expect(action.railway_flow).to eq railway_flow
          end
        end
      end
    end
  end
end
