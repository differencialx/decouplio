# frozen_string_literal: true

RSpec.describe 'Step as Doby' do
  include_context 'with basic spec setup'

  context 'when after step' do
    let(:action_block) { when_step_as_doby_after_step }
    let(:input_params) do
      {
        user_param: user_param,
        assign_user: assign_user
      }
    end

    context 'when assign_user success' do
      context 'when user_param is truthy' do
        let(:assign_user) { true }
        let(:user_param) { 'SomeName' }
        let(:railway_flow) { %i[assign_user AssignStepAsDoby finish] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              assign_user: assign_user,
              user: user_param,
              current_user: user_param,
              result: "Current user is: #{user_param}",
              fail_one: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when user_param is falsy' do
        let(:assign_user) { true }
        let(:user_param) { false }
        let(:railway_flow) { %i[assign_user AssignStepAsDoby fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              assign_user: assign_user,
              user: user_param,
              current_user: user_param,
              result: nil,
              fail_one: 'Failure'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when assign_user failure' do
      let(:assign_user) { false }
      let(:user_param) { false }
      let(:railway_flow) { %i[assign_user fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            assign_user: assign_user,
            user: user_param,
            current_user: nil,
            result: nil,
            fail_one: 'Failure'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when before step' do
    let(:action_block) { when_step_as_doby_before_step }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when InitStepAsDoby success' do
      context 'when step_one success' do
        let(:railway_flow) { %i[InitStepAsDoby step_one] }
        let(:stub_dummy_value) { 22 }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              init: stub_dummy_value,
              result: stub_dummy_value * 2,
              fail_one: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end
    end

    context 'when InitStepAsDoby failure' do
      let(:railway_flow) { %i[InitStepAsDoby fail_one] }
      let(:stub_dummy_value) { false }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            init: stub_dummy_value,
            result: nil,
            fail_one: 'Failure'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'stub dummy was called'
    end
  end

  context 'when after step with on_success on_failure' do
    let(:action_block) { when_step_as_doby_after_step_with_on_success_on_failure }
    let(:input_params) do
      {
        param1: param1
      }
    end

    context 'when step one success' do
      let(:param1) { true }
      let(:railway_flow) { %i[step_one fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: param1,
            step_two: nil,
            step_three: nil,
            doby_val: nil,
            fail_one: 'Failure'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:param1) { false }
      let(:railway_flow) { %i[step_one step_three] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: param1,
            step_two: nil,
            step_three: 'Success',
            doby_val: nil,
            fail_one: nil
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after step with on_success on_failure points to doby' do
    let(:action_block) { when_step_as_doby_after_step_with_on_success_on_failure_to_doby }
    let(:input_params) do
      {
        param1: param1
      }
    end

    context 'when step one success' do
      let(:param1) { true }
      let(:railway_flow) { %i[step_one fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: param1,
            step_two: nil,
            doby_val: nil,
            step_three: nil,
            fail_one: 'Failure'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:param1) { false }
      let(:railway_flow) { %i[step_one AssignStepAsDoby step_two step_three] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: param1,
            step_two: 'Success',
            step_three: 'Success',
            doby_val: 'Some value',
            fail_one: nil
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when before fail' do
    let(:action_block) { when_step_as_doby_before_fail }
    let(:input_params) do
      {
        outcome: outcome
      }
    end

    context 'when step_one success' do
      let(:outcome) { true }
      let(:railway_flow) { %i[step_one AssignStepAsDoby] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: outcome,
            user: 'Some user',
            current_user: 'Some user',
            fail_one: nil
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:outcome) { false }
      let(:railway_flow) { %i[step_one fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: outcome,
            user: 'Some user',
            current_user: nil,
            fail_one: 'Failure'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after fail' do
    let(:action_block) { when_step_as_doby_after_fail }
    let(:input_params) do
      {
        outcome: outcome
      }
    end

    context 'when step_one success' do
      let(:outcome) { true }
      let(:railway_flow) { %i[step_one AssignStepAsDoby] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: outcome,
            user: 'Some user',
            current_user: 'Some user',
            fail_one: nil
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:outcome) { false }
      let(:railway_flow) { %i[step_one fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: outcome,
            user: 'Some user',
            current_user: nil,
            fail_one: 'Failure'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after fail on_success on_failure' do
    let(:action_block) { when_step_as_doby_after_fail_on_success_on_failure }
    let(:input_params) do
      {
        outcome: outcome,
        fail_one_param: fail_one_param
      }
    end
    let(:fail_one_param) { true }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when step_one success' do
      let(:outcome) { true }

      context 'when InitStepAsDoby success' do
        let(:stub_dummy_value) { true }
        let(:railway_flow) { %i[step_one step_two InitStepAsDoby] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              step_one: outcome,
              step_two: 'Success',
              init: stub_dummy_value,
              fail_one: nil,
              fail_two: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when InitStepAsDoby failure' do
        let(:stub_dummy_value) { false }
        let(:railway_flow) { %i[step_one step_two InitStepAsDoby fail_two] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              step_one: outcome,
              step_two: 'Success',
              init: stub_dummy_value,
              fail_one: nil,
              fail_two: 'Failure'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end
    end

    context 'when step_one failure' do
      let(:outcome) { false }

      context 'when fail_one success' do
        let(:fail_one_param) { true }
        let(:stub_dummy_value) { true }
        let(:railway_flow) { %i[step_one fail_one fail_two] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              step_one: outcome,
              step_two: nil,
              init: nil,
              fail_one: fail_one_param,
              fail_two: 'Failure'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was not called'
      end

      context 'when fail_one failure' do
        context 'when InitStepAsDoby success' do
          let(:fail_one_param) { false }
          let(:stub_dummy_value) { true }
          let(:railway_flow) { %i[step_one fail_one InitStepAsDoby] }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              state: {
                step_one: outcome,
                step_two: nil,
                init: stub_dummy_value,
                fail_one: fail_one_param,
                fail_two: nil
              },
              errors: {}
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when InitStepAsDoby failure' do
          let(:fail_one_param) { false }
          let(:stub_dummy_value) { false }
          let(:railway_flow) { %i[step_one fail_one InitStepAsDoby fail_two] }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                step_one: outcome,
                step_two: nil,
                init: stub_dummy_value,
                fail_one: fail_one_param,
                fail_two: 'Failure'
              },
              errors: {}
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end
      end
    end
  end

  context 'when before pass' do
    let(:action_block) { when_step_as_doby_before_pass }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when InitStepAsDoby success' do
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[InitStepAsDoby pass_one step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            init: stub_dummy_value,
            pass_one: stub_dummy_value,
            step_one: 'Success'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'stub dummy was called'
    end

    context 'when InitStepAsDoby failure' do
      let(:stub_dummy_value) { false }
      let(:railway_flow) { %i[InitStepAsDoby] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            init: stub_dummy_value,
            pass_one: nil,
            step_one: nil
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'stub dummy was called'
    end
  end

  context 'when after pass' do
    let(:action_block) { when_step_as_doby_after_pass }

    context 'when AssignStepAsDoby success' do
      let(:railway_flow) { %i[pass_one AssignStepAsDoby step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            user: 'Some user',
            current_user: 'Some user',
            step_one: 'Some user'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when before octo' do
    let(:action_block) { when_step_as_doby_before_octo }

    context 'when step_palp success' do
      let(:railway_flow) { %i[AssignStepAsDoby octo_name octo1 step_palp] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            octo_key: :octo1,
            step_palp: 'Success'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after octo' do
    let(:action_block) { when_step_as_doby_after_octo }
    let(:input_params) do
      {
        palp_param: palp_param,
        octo_key: :octo1
      }
    end

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when step_palp success' do
      let(:palp_param) { true }

      context 'when InitStepAsDoby success' do
        let(:stub_dummy_value) { true }
        let(:railway_flow) { %i[octo_name octo1 step_palp step_one InitStepAsDoby] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              octo_key: :octo1,
              step_palp: palp_param,
              step_one: 'Success',
              init: stub_dummy_value,
              fail_one: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when InitStepAsDoby failure' do
        let(:stub_dummy_value) { false }
        let(:railway_flow) { %i[octo_name octo1 step_palp step_one InitStepAsDoby fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              octo_key: :octo1,
              step_palp: palp_param,
              step_one: 'Success',
              init: stub_dummy_value,
              fail_one: 'Failure'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end
    end

    context 'when step_palp failure' do
      let(:palp_param) { false }
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[octo_name octo1 step_palp fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            octo_key: :octo1,
            step_palp: palp_param,
            step_one: nil,
            init: nil,
            fail_one: 'Failure'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'stub dummy was not called'
    end
  end

  context 'when before wrap' do
    let(:action_block) { when_step_as_doby_before_wrap }
    let(:stub_dummy_value) { 4 }
    let(:railway_flow) { %i[InitStepAsDoby some_wrap step_one] }
    let(:expected_state) do
      {
        action_status: :success,
        railway_flow: railway_flow,
        state: {
          init: stub_dummy_value,
          result: 8
        },
        errors: {}
      }
    end

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    it_behaves_like 'check action state'
    it_behaves_like 'stub dummy was called'
  end

  context 'when after wrap' do
    let(:action_block) { when_step_as_doby_after_wrap }
    let(:input_params) do
      {
        param1: param1
      }
    end

    context 'when step_one success' do
      let(:param1) { true }

      context 'when AssignStepAsDoby success' do
        let(:railway_flow) { %i[some_wrap step_one AssignStepAsDoby step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              step_one: param1,
              result: param1,
              step_two: 'Success',
              fail_one: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when step_one failure' do
      let(:param1) { false }

      context 'when AssignStepAsDoby failure' do
        let(:railway_flow) { %i[some_wrap step_one fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              step_one: param1,
              result: nil,
              step_two: nil,
              fail_one: 'Failure'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end
  end

  context 'when after wrap on_success on_failure' do
    let(:action_block) { when_step_as_doby_after_wrap_on_success_on_failure }
    let(:input_params) do
      {
        param1: param1
      }
    end

    context 'when step_one success' do
      let(:param1) { true }
      let(:railway_flow) { %i[some_wrap step_one fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: param1,
            result: nil,
            step_two: nil,
            fail_one: 'Failure'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:param1) { false }
      let(:railway_flow) { %i[some_wrap step_one AssignStepAsDoby fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: param1,
            result: param1,
            step_two: nil,
            fail_one: 'Failure'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when before resq' do
    let(:action_block) { when_step_as_doby_before_resq }

    context 'when InitStepAsDoby success' do
      let(:railway_flow) { %i[InitStepAsDoby step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: 'Success',
            init: true,
            fail_one: nil,
            error: nil
          },
          errors: {}
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_return(true)
      end

      it_behaves_like 'check action state'
      it_behaves_like 'stub dummy was called'
    end

    context 'when InitStepAsDoby failure' do
      let(:railway_flow) { %i[InitStepAsDoby fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: nil,
            init: false,
            fail_one: 'Failure',
            error: nil
          },
          errors: {}
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_return(false)
      end

      it_behaves_like 'check action state'
      it_behaves_like 'stub dummy was called'
    end

    context 'when InitStepAsDoby raises an error' do
      let(:error_message) { 'ArgumentError message' }
      let(:railway_flow) { %i[InitStepAsDoby handler fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: nil,
            init: nil,
            fail_one: 'Failure',
            error: error_message
          },
          errors: {}
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_raise(ArgumentError, error_message)
      end

      it_behaves_like 'check action state'
      it_behaves_like 'stub dummy was called'
    end
  end

  context 'when after resq' do
    let(:action_block) { when_step_as_doby_after_resq }
    let(:input_params) do
      {
        param1: param1
      }
    end

    context 'when step_one success' do
      let(:param1) { -> { true } }
      let(:railway_flow) { %i[step_one AssignStepAsDoby step_two] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: true,
            result: true,
            fail_one: nil,
            error: nil
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:param1) { -> { false } }
      let(:railway_flow) { %i[step_one fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: false,
            result: nil,
            fail_one: 'Failure',
            error: nil
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one raises an error' do
      let(:error_message) { 'ArgumentError message' }
      let(:param1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one handler fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: nil,
            result: nil,
            fail_one: 'Failure',
            error: error_message
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when inside wrap' do
    let(:action_block) { when_step_as_doby_inside_wrap }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when InitStepAsDoby success' do
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[some_wrap step_one InitStepAsDoby step_two] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: 'Success',
            step_two: 'Success',
            init: stub_dummy_value,
            fail_one: nil
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'stub dummy was called'
    end

    context 'when InitStepAsDoby failure' do
      let(:stub_dummy_value) { false }
      let(:railway_flow) { %i[some_wrap step_one InitStepAsDoby fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: 'Success',
            step_two: nil,
            init: stub_dummy_value,
            fail_one: 'Failure'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'stub dummy was called'
    end
  end

  context 'when doby adds error' do
    let(:action_block) { when_step_as_doby_adds_error }
    let(:input_params) do
      {
        doby1: doby1
      }
    end
    let(:doby1) { nil }

    context 'when doby success' do
      let(:doby1) { true }
      let(:railway_flow) { %i[step_one AddErrorStepAsDoby step_two] }
      let(:errors) do
        {
          step_one_error: ['Lol']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: false,
            step_two: 'Success',
            fail_one: nil
          },
          errors: errors
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when doby failure' do
      let(:doby1) { false }
      let(:railway_flow) { %i[step_one AddErrorStepAsDoby fail_one] }
      let(:errors) do
        {
          step_one_error: ['Lol']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: 'Failure'
          },
          errors: errors
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when on_success on_failure to steps' do
    let(:action_block) { when_step_as_doby_on_success_on_failure_to_steps }
    let(:input_params) do
      {
        doby1: doby1
      }
    end

    context 'when doby success' do
      let(:doby1) { -> { true } }
      let(:railway_flow) { %i[ForkStepAsDoby fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: nil,
            fail_one: 'Failure',
            result: true
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when doby failure' do
      let(:doby1) { -> { false } }
      let(:railway_flow) { %i[ForkStepAsDoby step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: 'Success',
            fail_one: nil,
            result: true
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when on_success on_failure to PASS FAIL' do
    let(:action_block) { when_step_as_doby_on_success_on_failure_pass_fail }
    let(:input_params) do
      {
        doby1: doby1
      }
    end

    context 'when doby success' do
      let(:doby1) { -> { true } }
      let(:railway_flow) { %i[ForkStepAsDoby fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: nil,
            fail_one: 'Failure',
            result: 'Result'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when doby failure' do
      let(:doby1) { -> { false } }
      let(:railway_flow) { %i[ForkStepAsDoby step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: 'Success',
            fail_one: nil,
            result: 'Result'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when on_success finish_him' do
    let(:action_block) { when_step_as_doby_on_success_finish_him }
    let(:input_params) do
      {
        doby1: doby1
      }
    end

    context 'when doby success' do
      let(:doby1) { -> { true } }
      let(:railway_flow) { %i[ForkStepAsDoby] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: nil,
            fail_one: nil,
            result: 'Result'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when doby failure' do
      let(:doby1) { -> { false } }
      let(:railway_flow) { %i[ForkStepAsDoby fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: nil,
            fail_one: 'Failure',
            result: 'Result'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when on_failure finish_him' do
    let(:action_block) { when_step_as_doby_on_failure_finish_him }
    let(:input_params) do
      {
        doby1: doby1
      }
    end

    context 'when doby success' do
      let(:doby1) { -> { true } }
      let(:railway_flow) { %i[ForkStepAsDoby step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: 'Success',
            fail_one: nil,
            result: 'Result'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when doby failure' do
      let(:doby1) { -> { false } }
      let(:railway_flow) { %i[ForkStepAsDoby] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: nil,
            fail_one: nil,
            result: 'Result'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when finish_him on_success' do
    let(:action_block) { when_step_as_doby_finish_him_on_success }
    let(:input_params) do
      {
        doby1: doby1
      }
    end

    context 'when doby success' do
      let(:doby1) { -> { true } }
      let(:railway_flow) { %i[ForkStepAsDoby] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: nil,
            fail_one: nil,
            result: 'Result'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when doby failure' do
      let(:doby1) { -> { false } }
      let(:railway_flow) { %i[ForkStepAsDoby fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: nil,
            fail_one: 'Failure',
            result: 'Result'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when finish_him on failure' do
    let(:action_block) { when_step_as_doby_finish_him_on_failure }
    let(:input_params) do
      {
        doby1: doby1
      }
    end

    context 'when doby success' do
      let(:doby1) { -> { true } }
      let(:railway_flow) { %i[ForkStepAsDoby step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: 'Success',
            fail_one: nil,
            result: 'Result'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when doby failure' do
      let(:doby1) { -> { false } }
      let(:railway_flow) { %i[ForkStepAsDoby] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            step_one: nil,
            fail_one: nil,
            result: 'Result'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when if condition' do
    let(:action_block) { when_step_as_doby_if_condition }
    let(:input_params) do
      {
        doby1: doby1,
        condition: condition
      }
    end
    let(:doby1) { -> { true } }

    context 'when condition success' do
      let(:condition) { true }
      let(:railway_flow) { %i[ForkStepAsDoby step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: 'Success',
            fail_one: nil,
            result: 'Result',
            condition: condition
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when condition failure' do
      let(:condition) { false }
      let(:railway_flow) { %i[step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: 'Success',
            fail_one: nil,
            result: nil,
            condition: condition
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when unless condition' do
    let(:action_block) { when_step_as_doby_unless_condition }
    let(:input_params) do
      {
        doby1: doby1,
        condition: condition
      }
    end
    let(:doby1) { -> { true } }

    context 'when condition failure' do
      let(:condition) { false }
      let(:railway_flow) { %i[ForkStepAsDoby step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: 'Success',
            fail_one: nil,
            result: 'Result',
            condition: condition
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when condition success' do
      let(:condition) { true }
      let(:railway_flow) { %i[step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            step_one: 'Success',
            fail_one: nil,
            result: nil,
            condition: condition
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end
end
