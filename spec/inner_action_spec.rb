# frozen_string_literal: true

RSpec.describe 'Use Decouplio::Action as a step' do
  include_context 'with basic spec setup'

  describe '.call' do
    let(:input_params) do
      {
        param1: param1,
        param2: param2,
        condition: condition
      }
    end
    let(:param1) { nil }
    let(:param2) { nil }
    let(:condition) { nil }

    context 'when inner action for step is not a Decouplio::Action' do
      let(:action_block) { when_inner_action_for_step_is_string_class }

      interpolation_values = [
        'step',
        'action: String'
      ]

      message = Decouplio::Const::Validations::ActionOptionClass::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::ActionClassError,
                      message: message
    end

    context 'when inner action for fail is not a Decouplio::Action' do
      let(:action_block) { when_inner_action_for_fail_is_string_class }

      interpolation_values = [
        'fail',
        'action: String'
      ]
      message = Decouplio::Const::Validations::ActionOptionClass::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::ActionClassError,
                      message: message
    end

    context 'when inner action for pass is not a Decouplio::Action' do
      let(:action_block) { when_inner_action_for_pass_is_string_class }

      interpolation_values = [
        'pass',
        'action: String'
      ]

      message = Decouplio::Const::Validations::ActionOptionClass::VALIDATION_ERROR_MESSAGE % interpolation_values

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::ActionClassError,
                      message: message
    end

    context 'when inner action pass' do
      let(:action_block) { when_inner_action }
      let(:param1) { 'pass' }
      let(:railway_flow) { %i[assign_inner_action_param InnerActionCases::InnerAction inner_step] }
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
      let(:railway_flow) do
        %i[
          assign_inner_action_param
          InnerActionCases::InnerAction
          inner_step
          handle_fail
          handle_fail
        ]
      end
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
        let(:railway_flow) { %i[assign_inner_action_param InnerActionCases::InnerAction inner_step handle_fail] }
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
        let(:railway_flow) do
          %i[
            assign_inner_action_param
            InnerActionCases::InnerAction
            inner_step
            handle_fail
            handle_fail
          ]
        end
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
        let(:railway_flow) { %i[assign_inner_action_param InnerActionCases::InnerAction inner_step step_one] }
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
        let(:railway_flow) do
          %i[
            assign_inner_action_param
            InnerActionCases::InnerAction
            inner_step
            handle_fail
            step_one
          ]
        end
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
        let(:railway_flow) { %i[assign_inner_action_param InnerActionCases::InnerAction inner_step] }
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
        let(:railway_flow) do
          %i[
            assign_inner_action_param
            InnerActionCases::InnerAction
            inner_step
            handle_fail
            handle_fail
          ]
        end
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
        let(:railway_flow) { %i[assign_inner_action_param InnerActionCases::InnerAction inner_step step_one] }
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
        let(:railway_flow) { %i[assign_inner_action_param InnerActionCases::InnerAction inner_step handle_fail] }
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
        let(:railway_flow) { %i[assign_inner_action_param step_one InnerActionCases::InnerAction inner_step fail_two] }
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
        let(:railway_flow) do
          %i[
            assign_inner_action_param
            step_one
            InnerActionCases::InnerAction
            inner_step
            handle_fail
            fail_two
          ]
        end
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
        let(:railway_flow) { %i[assign_inner_action_param step_one InnerActionCases::InnerAction inner_step step_two] }
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
        let(:railway_flow) do
          %i[
            assign_inner_action_param
            step_one
            InnerActionCases::InnerAction
            inner_step
            handle_fail
            fail_two
          ]
        end
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
        let(:railway_flow) { %i[assign_inner_action_param step_one InnerActionCases::InnerAction inner_step fail_two] }
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
        let(:railway_flow) do
          %i[
            assign_inner_action_param
            step_one
            InnerActionCases::InnerAction
            inner_step
            handle_fail
            step_two
          ]
        end
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
        let(:railway_flow) { %i[assign_inner_action_param step_one InnerActionCases::InnerAction inner_step] }
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
        let(:railway_flow) do
          %i[
            assign_inner_action_param
            step_one
            InnerActionCases::InnerAction
            inner_step
            handle_fail
            fail_two
          ]
        end
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
        let(:railway_flow) { %i[assign_inner_action_param step_one InnerActionCases::InnerAction inner_step fail_two] }
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
        let(:railway_flow) do
          %i[
            assign_inner_action_param
            step_one
            InnerActionCases::InnerAction
            inner_step
            handle_fail
          ]
        end
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
        let(:railway_flow) { %i[assign_inner_action_param step_one InnerActionCases::InnerAction inner_step] }
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
        let(:railway_flow) do
          %i[
            assign_inner_action_param
            step_one
            InnerActionCases::InnerAction
            inner_step
            handle_fail
            fail_two
          ]
        end
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
        let(:railway_flow) { %i[assign_inner_action_param step_one InnerActionCases::InnerAction inner_step fail_two] }
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
        let(:railway_flow) do
          %i[
            assign_inner_action_param
            step_one
            InnerActionCases::InnerAction
            inner_step
            handle_fail
          ]
        end
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
        let(:railway_flow) { %i[assign_inner_action_param step_one InnerActionCases::InnerAction inner_step step_two] }
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
        let(:railway_flow) do
          %i[
            assign_inner_action_param
            step_one
            InnerActionCases::InnerAction
            inner_step
            handle_fail
            step_two
          ]
        end
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
        let(:railway_flow) { %i[assign_inner_action_param step_one InnerActionCases::InnerAction inner_step] }
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
        let(:railway_flow) do
          %i[
            assign_inner_action_param
            step_one
            InnerActionCases::InnerAction
            inner_step
            handle_fail
          ]
        end
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

    context 'when inner action with if condition' do
      let(:action_block) { when_innder_action_if_condition }
      let(:param1) { 'pass' }
      let(:param2) { true }

      context 'when condition success' do
        let(:condition) { true }
        let(:railway_flow) do
          %i[
            assign_inner_action_param
            step_one
            InnerActionCases::InnerAction
            inner_step
          ]
        end
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_action_param: param1,
              result: true,
              step_one: param2,
              condition: condition
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when condition failure' do
        let(:condition) { false }
        let(:railway_flow) do
          %i[
            assign_inner_action_param
            step_one
          ]
        end
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              inner_action_param: param1,
              result: nil,
              step_one: param2,
              step_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end
  end
end
