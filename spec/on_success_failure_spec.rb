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
        custom_param: custom_param,
        process_fail_custom_fail_step: process_fail_custom_fail_step
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
    let(:process_fail_custom_fail_step) { true }

    context 'when finish_him on_success' do
      let(:action_block) { on_success_finish_him }
      let(:railway_flow) { %i[step_one step_two] }
      let(:param2) { true }

      it 'success' do
        expect(action).to be_success
        expect(action.railway_flow).to eq railway_flow
        expect(action[:result]).to eq param1
      end
    end

    context 'when finish_him on_failure' do
      let(:action_block) { on_failure_finish_him }
      let(:railway_flow) { %i[step_one step_two] }
      let(:param2) { false }

      it 'success' do
        expect(action).to be_failure
        expect(action.railway_flow).to eq railway_flow
        expect(action[:result]).to eq param1
      end
    end

    context 'when custom step on_success' do
      let(:action_block) { on_success_custom_step }
      let(:param2) { true }

      context 'when custom method moves on success track' do
        let(:railway_flow) { %i[step_one step_two custom_step custom_pass_step] }
        let(:custom_param) { true }

        it 'success' do
          expect(action).to be_success
          expect(action.railway_flow).to eq railway_flow
          expect(action[:result]).to eq 'Custom pass step'
        end
      end

      context 'when custom method moves on failure track' do
        let(:railway_flow) { %i[step_one step_two custom_step custom_fail_step] }
        let(:custom_param) { false }

        it 'success' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq railway_flow
          expect(action[:result]).to eq 'Custom fail step'
        end
      end
    end

    context 'when custom step on_failure' do
      let(:action_block) { on_failure_custom_step }
      let(:param2) { false }

      context 'when custom method moves on success track' do
        let(:railway_flow) { %i[step_one step_two custom_step custom_pass_step] }
        let(:custom_param) { true }

        it 'success' do
          expect(action).to be_success
          expect(action.railway_flow).to eq railway_flow
          expect(action[:result]).to eq 'Custom pass step'
        end
      end

      context 'when custom method moves on failure track' do
        let(:railway_flow) { %i[step_one step_two custom_step custom_fail_step] }
        let(:custom_param) { false }

        it 'success' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq railway_flow
          expect(action[:result]).to eq 'Custom fail step'
        end
      end
    end

    context 'when custom step with if on_failure' do
      let(:action_block) { on_failure_custom_step_with_if }

      context 'when process_fail_custom_fail_step is true' do
        let(:process_fail_custom_fail_step) { true }
        let(:railway_flow) { %i[step_one step_two custom_fail_step] }
        let(:param2) { false }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq railway_flow
          expect(action[:step_one]).to eq param1
          expect(action[:result]).to eq 'Custom fail step'
        end
      end

      context 'when process_fail_custom_fail_step is false' do
        let(:process_fail_custom_fail_step) { false }
        let(:railway_flow) { %i[step_one step_two] }
        let(:param2) { false }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq railway_flow
          expect(action[:step_one]).to eq param1
          expect(action[:result]).to be_nil
        end
      end
    end

    context 'when on_failure for fail leads to success track' do
      let(:param1) { false }

      before do
        allow(StubDummy).to receive(:call)
          .and_return(stub_dummy_value)
      end

      context 'when both on_success and on_failure present' do
        let(:action_block) { when_both_options_present_from_failure_to_success_track_on_success }

        context 'when fail step success' do
          let(:expected_railway_flow) { %i[step_one fail_one step_two] }
          let(:stub_dummy_value) { true }

          it 'success' do
            expect(action).to be_success
            expect(action.railway_flow).to eq expected_railway_flow
            expect(action[:step_one]).to eq param1
            expect(action[:step_two]).to eq 'Success'
            expect(action[:fail_two]).to be_nil
            expect(StubDummy).to have_received(:call)
          end
        end

        context 'when fail step failure' do
          let(:expected_railway_flow) { %i[step_one fail_one fail_two] }
          let(:stub_dummy_value) { false }

          it 'failure' do
            expect(action).to be_failure
            expect(action.railway_flow).to eq expected_railway_flow
            expect(action[:step_one]).to eq param1
            expect(action[:step_two]).to be_nil
            expect(action[:fail_two]).to eq 'Failure'
            expect(StubDummy).to have_received(:call)
          end
        end
      end

      context 'when only on_success option is present' do
        let(:action_block) { when_one_option_present_from_failure_to_success_track_on_success }

        context 'when fail step success' do
          let(:expected_railway_flow) { %i[step_one fail_one step_two] }
          let(:stub_dummy_value) { true }

          it 'success' do
            expect(action).to be_success
            expect(action.railway_flow).to eq expected_railway_flow
            expect(action[:step_one]).to eq param1
            expect(action[:step_two]).to eq 'Success'
            expect(action[:fail_two]).to be_nil
            expect(StubDummy).to have_received(:call)
          end
        end

        context 'when fail step failure' do
          let(:expected_railway_flow) { %i[step_one fail_one fail_two] }
          let(:stub_dummy_value) { false }

          it 'failure' do
            expect(action).to be_failure
            expect(action.railway_flow).to eq expected_railway_flow
            expect(action[:step_one]).to eq param1
            expect(action[:step_two]).to be_nil
            expect(action[:fail_two]).to eq 'Failure'
            expect(StubDummy).to have_received(:call)
          end
        end
      end
    end

    context 'when on_failure for fail leads to fail track' do
      let(:param1) { false }

      before do
        allow(StubDummy).to receive(:call)
          .and_return(stub_dummy_value)
      end

      context 'when both on_success and on_failure present' do
        let(:action_block) { when_both_options_present_from_failure_to_success_track_on_failure }

        context 'when fail step success' do
          let(:expected_railway_flow) { %i[step_one fail_one fail_two] }
          let(:stub_dummy_value) { true }

          it 'failure' do
            # expect(action).to be_failure
            expect(action.railway_flow).to eq expected_railway_flow
            expect(action[:step_one]).to eq param1
            expect(action[:step_two]).to be_nil
            expect(action[:fail_two]).to eq 'Failure'
            expect(StubDummy).to have_received(:call)
          end
        end

        context 'when fail step failure' do
          let(:expected_railway_flow) { %i[step_one fail_one step_two] }
          let(:stub_dummy_value) { false }

          it 'success' do
            expect(action).to be_success
            expect(action.railway_flow).to eq expected_railway_flow
            expect(action[:step_one]).to eq param1
            expect(action[:step_two]).to eq 'Success'
            expect(action[:fail_two]).to be_nil
            expect(StubDummy).to have_received(:call)
          end
        end
      end

      context 'when only on_success option is present' do
        let(:action_block) { when_one_option_present_from_failure_to_success_track_on_failure }

        context 'when fail step success' do
          let(:expected_railway_flow) { %i[step_one fail_one fail_two] }
          let(:stub_dummy_value) { true }

          it 'failure' do
            expect(action).to be_failure
            expect(action.railway_flow).to eq expected_railway_flow
            expect(action[:step_one]).to eq param1
            expect(action[:step_two]).to be_nil
            expect(action[:fail_two]).to eq 'Failure'
            expect(StubDummy).to have_received(:call)
          end
        end

        context 'when fail step failure' do
          let(:expected_railway_flow) { %i[step_one fail_one step_two] }
          let(:stub_dummy_value) { false }

          it 'success' do
            expect(action).to be_success
            expect(action.railway_flow).to eq expected_railway_flow
            expect(action[:step_one]).to eq param1
            expect(action[:step_two]).to eq 'Success'
            expect(action[:fail_two]).to be_nil
            expect(StubDummy).to have_received(:call)
          end
        end
      end
    end

    context 'when fail on_success is finish_him one option' do
      let(:action_block) { when_fail_on_success_finish_him_one_option }
      let(:param1) { false }

      before do
        allow(StubDummy).to receive(:call)
          .and_return(stub_dummy_value)
      end

      context 'when fail step success' do
        let(:expected_railway_flow) { %i[step_one fail_one] }
        let(:stub_dummy_value) { true }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:step_one]).to eq param1
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to be_nil
          expect(StubDummy).to have_received(:call)
        end
      end

      context 'when fail step failure' do
        let(:expected_railway_flow) { %i[step_one fail_one fail_two] }
        let(:stub_dummy_value) { false }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:step_one]).to eq param1
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to eq 'Failure'
          expect(StubDummy).to have_received(:call)
        end
      end
    end

    context 'when fail on_failure is finish_him one option' do
      let(:action_block) { when_fail_on_failure_finish_him_one_option }
      let(:param1) { false }

      before do
        allow(StubDummy).to receive(:call)
          .and_return(stub_dummy_value)
      end

      context 'when fail step success' do
        let(:expected_railway_flow) { %i[step_one fail_one fail_two] }
        let(:stub_dummy_value) { true }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:step_one]).to eq param1
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to eq 'Failure'
          expect(StubDummy).to have_received(:call)
        end
      end

      context 'when fail step failure' do
        let(:expected_railway_flow) { %i[step_one fail_one] }
        let(:stub_dummy_value) { false }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:step_one]).to eq param1
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to be_nil
          expect(StubDummy).to have_received(:call)
        end
      end
    end

    context 'when fail on_success is finish_him two options' do
      let(:action_block) { when_fail_on_success_finish_him_two_options }
      let(:param1) { false }

      before do
        allow(StubDummy).to receive(:call)
          .and_return(stub_dummy_value)
      end

      context 'when fail step success' do
        let(:expected_railway_flow) { %i[step_one fail_one] }
        let(:stub_dummy_value) { true }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:step_one]).to eq param1
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to be_nil
          expect(StubDummy).to have_received(:call)
        end
      end

      context 'when fail step failure' do
        let(:expected_railway_flow) { %i[step_one fail_one step_two] }
        let(:stub_dummy_value) { false }

        it 'success' do
          expect(action).to be_success
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:step_one]).to eq param1
          expect(action[:step_two]).to eq 'Success'
          expect(action[:fail_two]).to be_nil
          expect(StubDummy).to have_received(:call)
        end
      end
    end

    context 'when fail on_failure is finish_him two options' do
      let(:action_block) { when_fail_on_failure_finish_him_two_options }
      let(:param1) { false }

      before do
        allow(StubDummy).to receive(:call)
          .and_return(stub_dummy_value)
      end

      context 'when fail step success' do
        let(:expected_railway_flow) { %i[step_one fail_one fail_two] }
        let(:stub_dummy_value) { true }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:step_one]).to eq param1
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to eq 'Failure'
          expect(StubDummy).to have_received(:call)
        end
      end

      context 'when fail step failure' do
        let(:expected_railway_flow) { %i[step_one fail_one] }
        let(:stub_dummy_value) { false }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:step_one]).to eq param1
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to be_nil
          expect(StubDummy).to have_received(:call)
        end
      end
    end
  end
end
