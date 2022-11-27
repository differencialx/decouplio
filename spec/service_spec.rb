# frozen_string_literal: true

RSpec.describe 'Service cases' do
  include_context 'with basic spec setup'

  let(:input_params) do
    {
      param1: param1,
      octo_key: octo_key,
      condition: condition,
      serv1: serv1
    }
  end
  let(:param1) { nil }
  let(:octo_key) { nil }
  let(:condition) { nil }
  let(:serv1) { nil }

  context 'when instance service as step' do
    let(:action_block) { when_instance_service_as_step }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when Service success' do
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[assign_one assign_two InstanceService] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            one: 1,
            two: 2,
            result: 3
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when Service failure' do
      let(:stub_dummy_value) { false }
      let(:railway_flow) { %i[assign_one assign_two InstanceService] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            one: 1,
            two: 2,
            result: 3
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when class service as step' do
    let(:action_block) { when_class_service_as_step }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when Service success' do
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[assign_one assign_two ClassService] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            one: 1,
            two: 2,
            result: 3
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when Service failure' do
      let(:stub_dummy_value) { false }
      let(:railway_flow) { %i[assign_one assign_two ClassService] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            one: 1,
            two: 2,
            result: 3
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as step on_success points to it' do
    let(:action_block) { when_service_as_step_on_success_points_to_it }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when step_one success' do
      let(:param1) { true }

      context 'when Service success' do
        let(:stub_dummy_value) { true }
        let(:railway_flow) { %i[step_one Service] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              result: stub_dummy_value
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when Service failure' do
        let(:stub_dummy_value) { false }
        let(:railway_flow) { %i[step_one Service] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              result: stub_dummy_value
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when step_one failure' do
      let(:param1) { false }
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[step_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: nil,
            result: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as step on_failure points to it' do
    let(:action_block) { when_service_as_step_on_failure_points_to_it }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when step_one success' do
      let(:param1) { true }

      context 'when Service success' do
        let(:stub_dummy_value) { true }
        let(:railway_flow) { %i[step_one step_two Service] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: 'Success',
              result: stub_dummy_value
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when Service failure' do
        let(:stub_dummy_value) { false }
        let(:railway_flow) { %i[step_one step_two Service] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: 'Success',
              result: stub_dummy_value
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when step_one failure' do
      let(:param1) { false }
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[step_one Service] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: nil,
            result: stub_dummy_value
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as step finish_him' do
    let(:action_block) { when_service_as_step_finish_him }
    let(:param1) { true }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when Service success' do
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[step_one Service] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: nil,
            result: stub_dummy_value
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when Service failure' do
      let(:stub_dummy_value) { false }
      let(:railway_flow) { %i[step_one Service] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: nil,
            result: stub_dummy_value
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as fail' do
    let(:action_block) { when_service_as_fail }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when step_one success' do
      let(:param1) { true }
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[step_one step_two] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: 'Success',
            result: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:param1) { false }

      context 'when Service success' do
        let(:stub_dummy_value) { true }
        let(:railway_flow) { %i[step_one Service] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              result: stub_dummy_value
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when Service failure' do
        let(:stub_dummy_value) { false }
        let(:railway_flow) { %i[step_one Service] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              result: stub_dummy_value
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end
  end

  context 'when service as fail on_success points to it' do
    let(:action_block) { when_service_as_fail_on_success_points_to_it }
    let(:stub_dummy_value) { true }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when step_one success' do
      let(:param1) { true }
      let(:railway_flow) { %i[step_one Service] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: nil,
            result: stub_dummy_value
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:param1) { false }
      let(:railway_flow) { %i[step_one Service] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: nil,
            result: stub_dummy_value
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as fail on failure points to it' do
    let(:action_block) { when_service_as_fail_on_failure_points_to_it }
    let(:stub_dummy_value) { true }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

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
            result: nil,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:param1) { false }
      let(:railway_flow) { %i[step_one Service] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: nil,
            result: stub_dummy_value,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as pass' do
    let(:action_block) { when_service_as_pass }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when step_one success' do
      let(:param1) { true }

      context 'when Service success' do
        let(:stub_dummy_value) { true }
        let(:railway_flow) { %i[step_one Service step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: 'Success',
              result: stub_dummy_value,
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when Service failure' do
        let(:stub_dummy_value) { false }
        let(:railway_flow) { %i[step_one Service step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: 'Success',
              result: stub_dummy_value,
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when step_one failure' do
      let(:param1) { false }
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[step_one fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: nil,
            result: nil,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as pass on_success points to it' do
    let(:action_block) { when_service_as_pass_on_success_points_to_it }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when step_one success' do
      let(:param1) { true }

      context 'when service success' do
        let(:stub_dummy_value) { true }
        let(:railway_flow) { %i[step_one Service] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              result: stub_dummy_value,
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when service failure' do
        let(:stub_dummy_value) { false }
        let(:railway_flow) { %i[step_one Service] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: param1,
              step_two: nil,
              result: stub_dummy_value,
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when step_one failure' do
      let(:param1) { false }
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[step_one fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: nil,
            result: nil,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as pass on_failure points to it' do
    let(:action_block) { when_service_as_pass_on_failure_points_to_it }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when step_one success' do
      let(:param1) { true }
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[step_one step_two Service] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: 'Success',
            result: stub_dummy_value,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:param1) { false }
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[step_one Service] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: nil,
            result: stub_dummy_value,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as step with resq' do
    let(:action_block) { when_service_as_step_with_resq }

    context 'when Service success' do
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[Service step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: 'Success',
            result: stub_dummy_value,
            fail_one: nil,
            error: nil
          }
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_return(stub_dummy_value)
      end

      it_behaves_like 'check action state'
    end

    context 'when Service failure' do
      let(:stub_dummy_value) { false }
      let(:railway_flow) { %i[Service fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: nil,
            result: stub_dummy_value,
            fail_one: 'Failure',
            error: nil
          }
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_return(stub_dummy_value)
      end

      it_behaves_like 'check action state'
    end

    context 'when Service raises an error' do
      let(:error_message) { 'Argument error message' }
      let(:railway_flow) { %i[Service handler fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: nil,
            result: nil,
            fail_one: 'Failure',
            error: error_message
          }
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_raise(ArgumentError, error_message)
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as fail with resq' do
    let(:action_block) { when_service_as_fail_with_resq }
    let(:param1) { false }

    context 'when Service success' do
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[step_one Service fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: nil,
            result: stub_dummy_value,
            fail_one: 'Failure',
            error: nil
          }
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_return(stub_dummy_value)
      end

      it_behaves_like 'check action state'
    end

    context 'when Service failure' do
      let(:stub_dummy_value) { false }
      let(:railway_flow) { %i[step_one Service fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: nil,
            result: stub_dummy_value,
            fail_one: 'Failure',
            error: nil
          }
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_return(stub_dummy_value)
      end

      it_behaves_like 'check action state'
    end

    context 'when Service raises an error' do
      let(:error_message) { 'Argument error message' }
      let(:railway_flow) { %i[step_one Service handler fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: nil,
            result: nil,
            fail_one: 'Failure',
            error: error_message
          }
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_raise(ArgumentError, error_message)
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as pass with resq' do
    let(:action_block) { when_service_as_pass_with_resq }
    let(:param1) { true }

    context 'when Service success' do
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[step_one Service step_two] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: 'Success',
            result: stub_dummy_value,
            fail_one: nil,
            error: nil
          }
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_return(stub_dummy_value)
      end

      it_behaves_like 'check action state'
    end

    context 'when Service failure' do
      let(:stub_dummy_value) { false }
      let(:railway_flow) { %i[step_one Service step_two] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: 'Success',
            result: stub_dummy_value,
            fail_one: nil,
            error: nil
          }
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_return(stub_dummy_value)
      end

      it_behaves_like 'check action state'
    end

    context 'when Service raises an error' do
      let(:error_message) { 'Argument error message' }
      let(:railway_flow) { %i[step_one Service handler fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            step_two: nil,
            result: nil,
            fail_one: 'Failure',
            error: error_message
          }
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_raise(ArgumentError, error_message)
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as step inside wrap' do
    let(:action_block) { when_service_as_step_inside_wrap }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when some wrap success' do
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[some_wrap Service step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: 'Success',
            result: stub_dummy_value,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when some wrap failure' do
      let(:stub_dummy_value) { false }

      let(:railway_flow) { %i[some_wrap Service fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: nil,
            result: stub_dummy_value,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as step inside palp' do
    let(:action_block) { when_service_as_step_inside_palp }
    let(:octo_key) { :octo1 }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when Service success' do
      let(:stub_dummy_value) { true }
      let(:railway_flow) { %i[octo_name octo1 step_one Service step_two] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: 'Success',
            step_two: 'Success',
            result: stub_dummy_value,
            fail_one: nil,
            octo_key: octo_key
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when Service failure' do
      let(:stub_dummy_value) { false }
      let(:railway_flow) { %i[octo_name octo1 step_one Service fail_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: 'Success',
            step_two: nil,
            result: stub_dummy_value,
            fail_one: 'Failure',
            octo_key: octo_key
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as step with if condition' do
    let(:action_block) { when_service_as_step_with_if_condition }
    let(:stub_dummy_value) { true }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when condition pass' do
      let(:condition) { true }
      let(:railway_flow) { %i[step_one Service] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: 'Success',
            condition: condition,
            result: stub_dummy_value
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when condition fails' do
      let(:condition) { false }
      let(:railway_flow) { %i[step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: 'Success',
            condition: condition,
            result: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as fail with unless condition' do
    let(:action_block) { when_service_as_fail_with_unless_condition }
    let(:stub_dummy_value) { true }
    let(:param1) { false }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when condition pass' do
      let(:condition) { false }
      let(:railway_flow) { %i[step_one Service] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            condition: condition,
            result: stub_dummy_value
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when condition fails' do
      let(:condition) { true }
      let(:railway_flow) { %i[step_one] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: param1,
            condition: condition,
            result: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as pass with unless condition' do
    let(:action_block) { when_service_as_pass_with_unless_condition }
    let(:stub_dummy_value) { true }

    before do
      allow(StubDummy).to receive(:call)
        .and_return(stub_dummy_value)
    end

    context 'when condition pass' do
      let(:condition) { false }
      let(:railway_flow) { %i[step_one Service] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: 'Success',
            condition: condition,
            result: stub_dummy_value
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when condition fails' do
      let(:condition) { true }
      let(:railway_flow) { %i[step_one] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: 'Success',
            condition: condition,
            result: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as step adds errors' do
    let(:action_block) { when_as_step_service_adds_errors }

    context 'when service success' do
      let(:serv1) { true }
      let(:railway_flow) { %i[AddErrorService step_one] }
      let(:errors) do
        {
          key: ['ServLol']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: 'Success',
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when service failure' do
      let(:serv1) { false }
      let(:railway_flow) { %i[AddErrorService fail_one] }
      let(:errors) do
        {
          key: ['ServLol']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as fail adds errors' do
    let(:action_block) { when_as_fail_service_adds_errors }

    context 'when service success' do
      let(:serv1) { true }
      let(:railway_flow) { %i[step_one AddErrorService fail_one] }
      let(:errors) do
        {
          key: ['ServLol']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when service failure' do
      let(:serv1) { false }
      let(:railway_flow) { %i[step_one AddErrorService fail_one] }
      let(:errors) do
        {
          key: ['ServLol']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when service as pass adds errors' do
    let(:action_block) { when_as_pass_service_adds_errors }

    context 'when service success' do
      let(:serv1) { true }
      let(:railway_flow) { %i[AddErrorService step_one] }
      let(:errors) do
        {
          key: ['ServLol']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: 'Success',
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when service failure' do
      let(:serv1) { false }
      let(:railway_flow) { %i[AddErrorService step_one] }
      let(:errors) do
        {
          key: ['ServLol']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: 'Success',
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end
end
