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
      let(:action_block) { when_step_on_success_finish_him }
      let(:railway_flow) { %i[step_one step_two] }
      let(:param2) { true }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            result: param1
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when finish_him on_failure' do
      let(:action_block) { when_step_on_failure_finish_him }
      let(:railway_flow) { %i[step_one step_two] }
      let(:param2) { false }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            result: param1
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when custom step on_success' do
      let(:action_block) { when_step_on_success_custom_step }
      let(:param2) { true }

      context 'when custom method moves on success track' do
        let(:railway_flow) { %i[step_one step_two custom_step custom_pass_step] }
        let(:custom_param) { true }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              result: 'Custom pass step'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when custom method moves on failure track' do
        let(:railway_flow) { %i[step_one step_two custom_step custom_fail_step] }
        let(:custom_param) { false }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              result: 'Custom fail step'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when custom step on_failure' do
      let(:action_block) { when_step_on_failure_custom_step }
      let(:param2) { false }

      context 'when custom method moves on success track' do
        let(:railway_flow) { %i[step_one step_two custom_step custom_pass_step] }
        let(:custom_param) { true }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              result: 'Custom pass step'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when custom method moves on failure track' do
        let(:railway_flow) { %i[step_one step_two custom_step custom_fail_step] }
        let(:custom_param) { false }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              result: 'Custom fail step'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when custom step with if on_failure' do
      let(:action_block) { when_step_on_failure_custom_step_with_if }

      context 'when process_fail_custom_fail_step is true' do
        let(:process_fail_custom_fail_step) { true }
        let(:railway_flow) { %i[step_one step_two custom_fail_step] }
        let(:param2) { false }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              result: 'Custom fail step'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when process_fail_custom_fail_step is false' do
        let(:process_fail_custom_fail_step) { false }
        let(:railway_flow) { %i[step_one step_two] }
        let(:param2) { false }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              result: nil
            }
          }
        end

        it_behaves_like 'check action state'
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
          let(:railway_flow) { %i[step_one fail_one step_two] }
          let(:stub_dummy_value) { true }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: param1,
                step_two: 'Success',
                fail_two: nil
              }
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when fail step failure' do
          let(:railway_flow) { %i[step_one fail_one fail_two] }
          let(:stub_dummy_value) { false }

          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: param1,
                step_two: nil,
                fail_two: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end
      end

      context 'when only on_success option is present' do
        let(:action_block) { when_one_option_present_from_failure_to_success_track_on_success }

        context 'when fail step success' do
          let(:railway_flow) { %i[step_one fail_one step_two] }
          let(:stub_dummy_value) { true }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: param1,
                step_two: 'Success',
                fail_two: nil
              }
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when fail step failure' do
          let(:railway_flow) { %i[step_one fail_one fail_two] }
          let(:stub_dummy_value) { false }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: param1,
                step_two: nil,
                fail_two: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
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
          let(:railway_flow) { %i[step_one fail_one fail_two] }
          let(:stub_dummy_value) { true }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: param1,
                step_two: nil,
                fail_two: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when fail step failure' do
          let(:railway_flow) { %i[step_one fail_one step_two] }
          let(:stub_dummy_value) { false }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: param1,
                step_two: 'Success',
                fail_two: nil
              }
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end
      end

      context 'when only on_success option is present' do
        let(:action_block) { when_one_option_present_from_failure_to_success_track_on_failure }

        context 'when fail step success' do
          let(:railway_flow) { %i[step_one fail_one fail_two] }
          let(:stub_dummy_value) { true }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: param1,
                step_two: nil,
                fail_two: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when fail step failure' do
          let(:railway_flow) { %i[step_one fail_one step_two] }
          let(:stub_dummy_value) { false }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: param1,
                step_two: 'Success',
                fail_two: nil
              }
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
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
        let(:railway_flow) { %i[step_one fail_one] }
        let(:stub_dummy_value) { true }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when fail step failure' do
        let(:railway_flow) { %i[step_one fail_one fail_two] }
        let(:stub_dummy_value) { false }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
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
        let(:railway_flow) { %i[step_one fail_one fail_two] }
        let(:stub_dummy_value) { true }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when fail step failure' do
        let(:railway_flow) { %i[step_one fail_one] }
        let(:stub_dummy_value) { false }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
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
        let(:railway_flow) { %i[step_one fail_one] }
        let(:stub_dummy_value) { true }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when fail step failure' do
        let(:railway_flow) { %i[step_one fail_one step_two] }
        let(:stub_dummy_value) { false }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: 'Success',
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
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
        let(:railway_flow) { %i[step_one fail_one fail_two] }
        let(:stub_dummy_value) { true }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when fail step failure' do
        let(:railway_flow) { %i[step_one fail_one] }
        let(:stub_dummy_value) { false }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end
    end
  end
end
