# frozen_string_literal: true

RSpec.describe 'Use Decouplio::Action as a step' do
  include_context 'with basic spec setup'

  describe '.call' do
    let(:input_params) do
      {
        param1: param1,
        param2: param2
      }
    end
    let(:param1) { nil }
    let(:param2) { nil }

    context 'when inner action pass' do
      let(:action_block) { when_inner_action }
      let(:param1) { 'pass' }
      let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            inner_action_param: param1,
            result: true
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when inner action fails' do
      let(:action_block) { when_inner_action }
      let(:param1) { 'fail' }
      let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step handle_fail handle_fail] }
      let(:expected_errors) do
        {
          inner_step_failed: ['Something went wrong inner'],
          outer_step_failed: ['Something went wrong outer']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: expected_errors,
          state: {
            inner_action_param: param1,
            result: false
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when on_success' do
      let(:action_block) { when_inner_action_on_success }

      context 'when inner action success' do
        let(:param1) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step handle_fail] }
        let(:expected_errors) do
          {
            outer_step_failed: ['Something went wrong outer']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              inner_action_param: param1,
              result: true
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner action fails' do
        let(:param1) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step handle_fail handle_fail] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner'],
            outer_step_failed: ['Something went wrong outer']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              inner_action_param: param1,
              result: false
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when on failure' do
      let(:action_block) { when_inner_action_on_failure }

      context 'when inner action success' do
        let(:param1) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step step_one] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_action_param: param1,
              result: true,
              step_one: 'step_one'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner action fails' do
        let(:param1) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step handle_fail step_one] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              inner_action_param: param1,
              result: false,
              step_one: 'step_one'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when inner action finish him on_success' do
      let(:action_block) { when_inner_action_finish_him_on_success }

      context 'when inner action success' do
        let(:param1) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_action_param: param1,
              result: true,
              step_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner action fails' do
        let(:param1) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step handle_fail handle_fail] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner'],
            outer_step_failed: ['Something went wrong outer']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              inner_action_param: param1,
              result: false,
              step_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when inner action finish him on_failure' do
      let(:action_block) { when_inner_action_finish_him_on_failure }

      context 'when inner action success' do
        let(:param1) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step step_one] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_action_param: param1,
              result: true,
              step_one: 'step_one'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner action fails' do
        let(:param1) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step handle_fail] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              inner_action_param: param1,
              result: false,
              step_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when inner action as fail step' do
      let(:action_block) { when_inner_action_as_fail_step }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step fail_two] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_action_param: param1,
              result: true,
              step_one: param2,
              step_two: nil,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step handle_fail fail_two] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              inner_action_param: param1,
              result: false,
              step_one: param2,
              step_two: nil,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when inner action as fail step on_success' do
      let(:action_block) { when_inner_action_as_fail_step_on_success }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_action_param: param1,
              result: true,
              step_one: param2,
              step_two: 'Success',
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step handle_fail fail_two] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              inner_action_param: param1,
              result: false,
              step_one: param2,
              step_two: nil,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when inner action as fail on_failure' do
      let(:action_block) { when_inner_action_as_fail_step_on_failure }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step fail_two] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_action_param: param1,
              result: true,
              step_one: param2,
              step_two: nil,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step handle_fail step_two] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              inner_action_param: param1,
              result: false,
              step_one: param2,
              step_two: 'Success',
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when inner action as fail step on_success finish_him' do
      let(:action_block) { when_inner_action_as_fail_step_on_success_finish_him }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_action_param: param1,
              result: true,
              step_one: param2,
              step_two: nil,
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step handle_fail fail_two] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              inner_action_param: param1,
              result: false,
              step_one: param2,
              step_two: nil,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when inner action as fail step on_failure finish_him' do
      let(:action_block) { when_inner_action_as_fail_step_on_failure_finish_him }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step fail_two] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_action_param: param1,
              result: true,
              step_one: param2,
              step_two: nil,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step handle_fail] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              inner_action_param: param1,
              result: false,
              step_one: param2,
              step_two: nil,
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when inner action as fail step finish_him on_success' do
      let(:action_block) { when_inner_action_as_fail_step_finish_him_on_success }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_action_param: param1,
              result: true,
              step_one: param2,
              step_two: nil,
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step handle_fail fail_two] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              inner_action_param: param1,
              result: false,
              step_one: param2,
              step_two: nil,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when inner action as fail step finish_hiim on_failure' do
      let(:action_block) { when_inner_action_as_fail_step_finish_him_on_failure }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step fail_two] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_action_param: param1,
              result: true,
              step_one: param2,
              step_two: nil,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step handle_fail] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              inner_action_param: param1,
              result: false,
              step_one: param2,
              step_two: nil,
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when inner action as pass step' do
      let(:action_block) { when_inner_action_as_pass }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param step_one pass_one inner_step step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_action_param: param1,
              result: true,
              step_one: 'Success',
              step_two: 'Success'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param step_one pass_one inner_step handle_fail step_two] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              inner_action_param: param1,
              result: false,
              step_one: 'Success',
              step_two: 'Success'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when inner action as pass step with finish_him' do
      let(:action_block) { when_inner_action_as_pass_finish_him }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param step_one pass_one inner_step] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_action_param: param1,
              result: true,
              step_one: 'Success',
              step_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param step_one pass_one inner_step handle_fail] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              inner_action_param: param1,
              result: false,
              step_one: 'Success',
              step_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end
  end
end
