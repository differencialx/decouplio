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
        process_fail_custom_fail_step: process_fail_custom_fail_step,
        octo_key: octo_key,
        in1: in1
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
    let(:octo_key) { nil }
    let(:in1) { nil }

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

    context 'when step on_sucess PASS' do
      let(:action_block) { when_step_on_success_as_pass }

      context 'when step one success' do
        let(:param1) { true }
        let(:railway_flow) { %i[step_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: 'Success',
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when step one failure' do
        let(:param1) { false }
        let(:railway_flow) { %i[step_one fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              fail_one: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when step on_failure PASS' do
      let(:action_block) { when_step_on_failure_as_pass }

      context 'when step_one success' do
        let(:param1) { true }
        let(:railway_flow) { %i[step_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: 'Success',
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when step_one failure' do
        let(:param1) { false }
        let(:railway_flow) { %i[step_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: 'Success',
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when step on_success on_failure reverse' do
      let(:action_block) { when_step_on_success_on_failure_reverse }

      context 'when step_one success' do
        let(:param1) { true }
        let(:railway_flow) { %i[step_one fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              fail_one: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when step_one failure' do
        let(:param1) { false }
        let(:railway_flow) { %i[step_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: 'Success',
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when step on_sucess is last step with FAIL' do
      let(:action_block) { when_step_on_success_fail_last_step }

      context 'when step_two success' do
        let(:param2) { true }
        let(:railway_flow) { %i[step_one step_two] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: param2
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when step_two failure' do
        let(:param2) { false }
        let(:railway_flow) { %i[step_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: param2
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when fail on_success PASS' do
      let(:action_block) { when_fail_on_success_pass }

      context 'when fail_one success' do
        let(:param1) { true }
        let(:railway_flow) { %i[step_one fail_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              step_two: 'Success',
              fail_one: param1,
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when fail_one failure' do
        let(:param1) { false }
        let(:railway_flow) { %i[step_one fail_one fail_two] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              step_two: nil,
              fail_one: param1,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when fail on_failure PASS' do
      let(:action_block) { when_fail_on_failure_pass }

      context 'when fail_one success' do
        let(:param1) { true }
        let(:railway_flow) { %i[step_one fail_one fail_two] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              step_two: nil,
              fail_one: param1,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when fail_one failure' do
        let(:param1) { false }
        let(:railway_flow) { %i[step_one fail_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              step_two: 'Success',
              fail_one: param1,
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when fail on_success on_failure reverse' do
      let(:action_block) { when_fail_on_sucess_on_failure_reverse }

      context 'when fail_one success' do
        let(:param1) { true }
        let(:railway_flow) { %i[step_one fail_one fail_two] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              step_two: nil,
              fail_one: param1,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when fail_one failure' do
        let(:param1) { false }
        let(:railway_flow) { %i[step_one fail_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              step_two: 'Success',
              fail_one: param1,
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when fail on_success on_failure last step' do
      let(:action_block) { when_fail_on_success_on_failure_last_step }

      context 'when fail_one success' do
        let(:param1) { true }
        let(:railway_flow) { %i[step_one fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              fail_one: param1
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when fail_one failure' do
        let(:param1) { false }
        let(:railway_flow) { %i[step_one fail_one] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              fail_one: param1
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when wrap on_success PASS' do
      let(:action_block) { when_wrap_on_success_pass }

      context 'when some_wrap success' do
        let(:param2) { true }
        let(:railway_flow) { %i[some_wrap step_one step_two step_three] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: param2,
              step_three: 'Success',
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when some_wrap failure' do
        let(:param2) { false }
        let(:railway_flow) { %i[some_wrap step_one step_two fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: param2,
              step_three: nil,
              fail_one: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when wrap on_failure PASS' do
      let(:action_block) { when_wrap_on_failure_pass }

      context 'when some_wrap success' do
        let(:param2) { true }
        let(:railway_flow) { %i[some_wrap step_one step_two step_three] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: param2,
              step_three: 'Success',
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when some_wrap failure' do
        let(:param2) { false }
        let(:railway_flow) { %i[some_wrap step_one step_two step_three] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: param2,
              step_three: 'Success',
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when wrap on_success on_failure reverse' do
      let(:action_block) { when_wrap_on_sucess_on_failure_reverse }

      context 'when some_wrap success' do
        let(:param2) { true }
        let(:railway_flow) { %i[some_wrap step_one step_two fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: param2,
              step_three: nil,
              fail_one: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when some_wrap failure' do
        let(:param2) { false }
        let(:railway_flow) { %i[some_wrap step_one step_two step_three] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: param2,
              step_three: 'Success',
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when palp on_success PASS' do
      let(:action_block) { when_palp_on_success_pass }
      let(:octo_key) { :octo1 }

      context 'when palp_step_one success' do
        let(:param1) { true }
        let(:railway_flow) { %i[octo_name palp_step_one step_one] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              palp_step_one: param1,
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when palp_step_one failure' do
        let(:param1) { false }
        let(:railway_flow) { %i[octo_name palp_step_one fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: nil,
              palp_step_one: param1,
              fail_one: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when palp on_failure PASS' do
      let(:action_block) { when_palp_on_failure_pass }
      let(:octo_key) { :octo1 }

      context 'when palp_step_one success' do
        let(:param1) { true }
        let(:railway_flow) { %i[octo_name palp_step_one step_one] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              palp_step_one: param1,
              palp_fail_one: nil,
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when palp_step_one failure' do
        let(:param1) { false }
        let(:railway_flow) { %i[octo_name palp_step_one step_one] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              palp_step_one: param1,
              palp_fail_one: nil,
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when palp on_success on_failure reverse' do
      let(:action_block) { when_palp_on_success_on_failure_reverse }
      let(:octo_key) { :octo1 }

      context 'when palp_step_one success' do
        let(:param1) { true }
        let(:railway_flow) { %i[octo_name palp_step_one palp_fail_one fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: nil,
              palp_step_one: param1,
              palp_fail_one: 'Failure',
              fail_one: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when palp_step_two failure' do
        let(:param1) { false }
        let(:railway_flow) { %i[octo_name palp_step_one step_one] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              palp_step_one: param1,
              palp_fail_one: nil,
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when palp on_success on_failure last step' do
      let(:action_block) { when_palp_on_success_on_failure_last_palp_step }
      let(:octo_key) { :octo1 }

      context 'when palp_step_one success' do
        let(:param1) { true }
        let(:railway_flow) { %i[step_one octo_name palp_step_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              palp_step_one: param1
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when palp_step_one failure' do
        let(:param1) { false }
        let(:railway_flow) { %i[step_one octo_name palp_step_one] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              palp_step_one: param1
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when action as step is the last step' do
      let(:action_block) { when_action_step_as_step_is_last_step }

      context 'when inner_step success' do
        let(:in1) { -> { true } }
        let(:railway_flow) { %i[OnSuccessFailureCases::OnSOnFCasesAction inner_step] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_step: true
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner_step failure' do
        let(:in1) { -> { false } }
        let(:railway_flow) { %i[OnSuccessFailureCases::OnSOnFCasesAction inner_step] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_step: false
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when action as step is the last step reverse' do
      let(:action_block) { when_action_step_as_step_is_last_step_reverse }

      context 'when inner_step success' do
        let(:in1) { -> { true } }
        let(:railway_flow) { %i[OnSuccessFailureCases::OnSOnFCasesAction inner_step] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_step: true
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner_step failure' do
        let(:in1) { -> { false } }
        let(:railway_flow) { %i[OnSuccessFailureCases::OnSOnFCasesAction inner_step] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_step: false
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when action as fail is the last step' do
      let(:action_block) { when_action_step_as_fail_is_last_step }

      context 'when inner_step success' do
        let(:in1) { -> { true } }
        let(:railway_flow) { %i[step_one OnSuccessFailureCases::OnSOnFCasesAction inner_step] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              inner_step: true
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner_step failure' do
        let(:in1) { -> { false } }
        let(:railway_flow) { %i[step_one OnSuccessFailureCases::OnSOnFCasesAction inner_step] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              inner_step: false
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when action as fail is the last step reverse' do
      let(:action_block) { when_action_step_as_fail_is_last_step_reverse }

      context 'when inner_step success' do
        let(:in1) { -> { true } }
        let(:railway_flow) { %i[step_one OnSuccessFailureCases::OnSOnFCasesAction inner_step] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              inner_step: true
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner_step failure' do
        let(:in1) { -> { false } }
        let(:railway_flow) { %i[step_one OnSuccessFailureCases::OnSOnFCasesAction inner_step] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              inner_step: false
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when service as step is last step' do
      let(:action_block) { when_service_step_as_step_is_last_step }

      context 'when service success' do
        let(:in1) { -> { true } }
        let(:railway_flow) { %i[OnSuccessFailureCases::OnSOnFCasesService] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_step: true
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when service failure' do
        let(:in1) { -> { false } }
        let(:railway_flow) { %i[OnSuccessFailureCases::OnSOnFCasesService] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_step: false
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when service as step is the last step reverse' do
      let(:action_block) { when_service_step_as_step_is_last_step_reverse }

      context 'when service success' do
        let(:in1) { -> { true } }
        let(:railway_flow) { %i[OnSuccessFailureCases::OnSOnFCasesService] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_step: true
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when service failure' do
        let(:in1) { -> { false } }
        let(:railway_flow) { %i[OnSuccessFailureCases::OnSOnFCasesService] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_step: false
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when service as fail is the last step' do
      let(:action_block) { when_service_step_as_fail_is_last_step }

      context 'when service success' do
        let(:in1) { -> { true } }
        let(:railway_flow) { %i[step_one OnSuccessFailureCases::OnSOnFCasesService] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              inner_step: true
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when service failure' do
        let(:in1) { -> { false } }
        let(:railway_flow) { %i[step_one OnSuccessFailureCases::OnSOnFCasesService] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              inner_step: false
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when service as fail the last steo reverse' do
      let(:action_block) { when_service_step_as_fail_is_last_step_reverse }

      context 'when service success' do
        let(:in1) { -> { true } }
        let(:railway_flow) { %i[step_one OnSuccessFailureCases::OnSOnFCasesService] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              inner_step: true
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when service failure' do
        let(:in1) { -> { false } }
        let(:railway_flow) { %i[step_one OnSuccessFailureCases::OnSOnFCasesService] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              inner_step: false
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end
  end
end
