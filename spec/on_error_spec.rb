# frozen_string_literal: true

RSpec.describe 'on_error cases' do
  include_context 'with basic spec setup'

  let(:input_params) do
    {
      s1: s1,
      f1: f1,
      p1: p1,
      p2: p2,
      pf1: pf1,
      octo_key: octo_key
    }
  end
  let(:s1) { nil }
  let(:f1) { nil }
  let(:p1) { nil }
  let(:p2) { nil }
  let(:pf1) { nil }
  let(:octo_key) { nil }
  let(:error_message) { 'ArgumentError message' }

  context 'when step on_error to step' do
    let(:action_block) { when_step_on_error_to_step }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: 'Success',
            fail_one: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one handler_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            step_two: 'Success',
            fail_one: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when step on_error to PASS' do
    let(:action_block) { when_step_on_error_to_pass }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: 'Success',
            fail_one: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one handler_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            step_two: 'Success',
            fail_one: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when step on_error to FAIL' do
    let(:action_block) { when_step_on_error_to_fail }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: 'Success',
            fail_one: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one handler_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            step_two: nil,
            fail_one: 'Failure',
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when step on_error finish_him' do
    let(:action_block) { when_step_on_error_finish_him }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: 'Success',
            fail_one: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one handler_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            step_two: nil,
            fail_one: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when step finish_him on_error' do
    let(:action_block) { when_step_finish_him_on_error }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: 'Success',
            fail_one: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one handler_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            step_two: nil,
            fail_one: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when fail on_error to step' do
    let(:action_block) { when_fail_on_error_to_step }

    context 'when fail_one success' do
      let(:f1) { -> { true } }
      let(:railway_flow) { %i[step_one fail_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: true,
            fail_two: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when fail_one failure' do
      let(:f1) { -> { false } }
      let(:railway_flow) { %i[step_one fail_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: false,
            fail_two: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when fail_one raises an error' do
      let(:f1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one fail_one handler_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: 'Success',
            fail_one: nil,
            fail_two: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when fail on_error to PASS' do
    let(:action_block) { when_fail_on_error_to_pass }

    context 'when fail_one success' do
      let(:f1) { -> { true } }
      let(:railway_flow) { %i[step_one fail_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: true,
            fail_two: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when fail_one failure' do
      let(:f1) { -> { false } }
      let(:railway_flow) { %i[step_one fail_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: false,
            fail_two: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when fail_one raises an error' do
      let(:f1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one fail_one handler_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: 'Success',
            fail_one: nil,
            fail_two: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when fail on_error to FAIL' do
    let(:action_block) { when_fail_on_error_to_fail }

    context 'when fail_one success' do
      let(:f1) { -> { true } }
      let(:railway_flow) { %i[step_one fail_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: true,
            fail_two: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when fail_one failure' do
      let(:f1) { -> { false } }
      let(:railway_flow) { %i[step_one fail_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: false,
            fail_two: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when fail_one raises an error' do
      let(:f1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one fail_one handler_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: nil,
            fail_two: 'Failure',
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when fail on_error finish_him' do
    let(:action_block) { when_fail_on_error_finish_him }

    context 'when fail_one success' do
      let(:f1) { -> { true } }
      let(:railway_flow) { %i[step_one fail_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: true,
            fail_two: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when fail_one failure' do
      let(:f1) { -> { false } }
      let(:railway_flow) { %i[step_one fail_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: false,
            fail_two: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when fail_one raises an error' do
      let(:f1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one fail_one handler_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: nil,
            fail_two: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when fail finish_him on_error' do
    let(:action_block) { when_fail_finish_him_on_error }

    context 'when fail_one success' do
      let(:f1) { -> { true } }
      let(:railway_flow) { %i[step_one fail_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: true,
            fail_two: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when fail_one failure' do
      let(:f1) { -> { false } }
      let(:railway_flow) { %i[step_one fail_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: false,
            fail_two: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when fail_one raises an error' do
      let(:f1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one fail_one handler_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: nil,
            fail_two: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when pass on_error to step' do
    let(:action_block) { when_pass_on_error_to_step }

    context 'when pass_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[pass_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: true,
            step_two: 'Success',
            fail_one: nil,
            fail_two: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when pass_one failure' do
      let(:p1) { -> { false } }
      let(:railway_flow) { %i[pass_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: false,
            step_two: 'Success',
            fail_one: nil,
            fail_two: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when pass_one raises an error' do
      let(:p1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[pass_one handler_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: nil,
            step_two: nil,
            fail_one: nil,
            fail_two: 'Failure',
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when pass on_error PASS' do
    let(:action_block) { when_pass_on_error_to_pass }

    context 'when pass_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[pass_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: true,
            step_two: 'Success',
            fail_two: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when pass_one failure' do
      let(:p1) { -> { false } }
      let(:railway_flow) { %i[pass_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: false,
            step_two: 'Success',
            fail_two: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when pass_one raises an error' do
      let(:p1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[pass_one handler_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: nil,
            step_two: 'Success',
            fail_two: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when pass on_error to FAIL' do
    let(:action_block) { when_pass_on_error_to_fail }

    context 'when pass_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[pass_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: true,
            step_two: 'Success',
            fail_two: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when pass_one failure' do
      let(:p1) { -> { false } }
      let(:railway_flow) { %i[pass_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: false,
            step_two: 'Success',
            fail_two: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when pass_one raises an error' do
      let(:p1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[pass_one handler_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: nil,
            step_two: nil,
            fail_two: 'Failure',
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when pass on_error finish_him' do
    let(:action_block) { when_pass_on_error_finish_him }

    context 'when pass_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[pass_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: true,
            step_two: 'Success',
            fail_two: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when pass_one failure' do
      let(:p1) { -> { false } }
      let(:railway_flow) { %i[pass_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: false,
            step_two: 'Success',
            fail_two: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when pass_one raises an error' do
      let(:p1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[pass_one handler_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: nil,
            step_two: nil,
            fail_two: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when pass finish_him on_error' do
    let(:action_block) { when_pass_finish_him_on_error }

    context 'when pass_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[pass_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: true,
            step_two: 'Success',
            fail_two: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when pass_one failure' do
      let(:p1) { -> { false } }
      let(:railway_flow) { %i[pass_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: false,
            step_two: 'Success',
            fail_two: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when pass_one raises an error' do
      let(:p1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[pass_one handler_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            pass_one: nil,
            step_two: nil,
            fail_two: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when wrap on_error to step' do
    let(:action_block) { when_wrap_on_error_to_step }

    context 'when some wrap success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[some_wrap step_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: 'Success',
            fail_one: nil,
            fail_two: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when some wrap failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[some_wrap step_one fail_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: 'Failure',
            fail_two: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when some wrap raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[some_wrap step_one handler_one fail_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            step_two: nil,
            fail_one: nil,
            fail_two: 'Failure',
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when wrap on_error to pass' do
    let(:action_block) { when_wrap_on_error_to_pass }

    context 'when some wrap success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[some_wrap step_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: 'Success',
            fail_one: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when some wrap failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[some_wrap step_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when some wrap raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[some_wrap step_one handler_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            step_two: 'Success',
            fail_one: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when wrap on_error to FAIL' do
    let(:action_block) { when_wrap_on_error_to_fail }

    context 'when some wrap success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[some_wrap step_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: 'Success',
            fail_one: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when some wrap failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[some_wrap step_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when some wrap raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[some_wrap step_one handler_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            step_two: nil,
            fail_one: 'Failure',
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when wrap finish_him on_error' do
    let(:action_block) { when_wrap_finish_him_on_error }

    context 'when some wrap success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[some_wrap step_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: 'Success',
            fail_one: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when some wrap failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[some_wrap step_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when some wrap raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[some_wrap step_one handler_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            step_two: nil,
            fail_one: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when wrap on_error finish_him' do
    let(:action_block) { when_wrap_on_error_finish_him }

    context 'when some wrap success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[some_wrap step_one step_two] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: 'Success',
            fail_one: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when some wrap failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[some_wrap step_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when some wrap raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[some_wrap step_one handler_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            step_two: nil,
            fail_one: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when palp on_error to step inside_palp' do
    let(:action_block) { when_palp_on_error_to_step_inside_palp }
    let(:octo_key) { :octo1 }

    context 'when palp_step_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one palp_step_two step_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: true,
            palp_step_two: 'Success',
            palp_fail_one: nil,
            step_one: 'Success',
            fail_one: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_step_one failure' do
      let(:p1) { -> { false } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one palp_fail_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: false,
            palp_step_two: nil,
            palp_fail_one: 'Failure',
            step_one: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_step_one raises an error' do
      let(:p1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one handler_one palp_step_two step_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: nil,
            palp_step_two: 'Success',
            palp_fail_one: nil,
            step_one: 'Success',
            fail_one: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when palp on_error to PASS' do
    let(:action_block) { when_palp_on_error_to_pass }
    let(:octo_key) { :octo1 }

    context 'when palp_step_two success' do
      let(:p2) { -> { true } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one palp_step_two step_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: 'Success',
            palp_step_two: true,
            step_one: 'Success',
            fail_one: nil,
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_step_two failure' do
      let(:p2) { -> { false } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one palp_step_two fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: 'Success',
            palp_step_two: false,
            step_one: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_step_two raises an error' do
      let(:p2) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one palp_step_two handler_one step_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: 'Success',
            palp_step_two: nil,
            step_one: 'Success',
            fail_one: nil,
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when palp on_error to FAIL' do
    let(:action_block) { when_palp_on_error_to_fail }
    let(:octo_key) { :octo1 }

    context 'when palp_fail_one success' do
      let(:pf1) { -> { true } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one palp_step_two palp_fail_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: 'Success',
            palp_step_two: false,
            palp_fail_one: true,
            step_one: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_fail_one failure' do
      let(:pf1) { -> { false } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one palp_step_two palp_fail_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: 'Success',
            palp_step_two: false,
            palp_fail_one: false,
            step_one: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_fail_one raises an error' do
      let(:pf1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one palp_step_two palp_fail_one handler_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: 'Success',
            palp_step_two: false,
            palp_fail_one: nil,
            step_one: nil,
            fail_one: 'Failure',
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when palp finish_him on_error' do
    let(:action_block) { when_palp_finish_him_on_error }
    let(:octo_key) { :octo1 }

    context 'when palp_fail_one success' do
      let(:pf1) { -> { true } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one palp_step_two palp_fail_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: 'Success',
            palp_step_two: false,
            palp_fail_one: true,
            step_one: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_fail_one failure' do
      let(:pf1) { -> { false } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one palp_step_two palp_fail_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: 'Success',
            palp_step_two: false,
            palp_fail_one: false,
            step_one: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_fail_one raises an error' do
      let(:pf1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one palp_step_two palp_fail_one handler_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: 'Success',
            palp_step_two: false,
            palp_fail_one: nil,
            step_one: nil,
            fail_one: 'Failure',
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when palp on_error finish_him' do
    let(:action_block) { when_palp_on_error_finish_him }
    let(:octo_key) { :octo1 }

    context 'when palp_fail_one success' do
      let(:pf1) { -> { true } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one palp_step_two palp_fail_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: 'Success',
            palp_step_two: false,
            palp_fail_one: true,
            step_one: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_fail_one failure' do
      let(:pf1) { -> { false } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one palp_step_two palp_fail_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: 'Success',
            palp_step_two: false,
            palp_fail_one: false,
            step_one: nil,
            fail_one: 'Failure',
            handler_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_fail_one raises an error' do
      let(:pf1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[octo_name octo1 palp_step_one palp_step_two palp_fail_one handler_one fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            palp_step_one: 'Success',
            palp_step_two: false,
            palp_fail_one: nil,
            step_one: nil,
            fail_one: 'Failure',
            handler_one: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when doby on_error to step' do
    let(:action_block) { when_doby_on_error_to_step }

    context 'when OnErrorDoby success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[OnErrorDoby step_two step_three] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: true,
            fail_one: nil,
            step_two: 'Success',
            step_three: 'Success',
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: false,
            fail_one: 'Failure',
            step_two: nil,
            step_three: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[OnErrorDoby handle_error step_three] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: nil,
            fail_one: nil,
            step_two: nil,
            step_three: 'Success',
            handle_error: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when doby on_error to PASS' do
    let(:action_block) { when_doby_on_error_to_pass }

    context 'when OnErrorDoby success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[OnErrorDoby step_two step_three] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: true,
            fail_one: nil,
            step_two: 'Success',
            step_three: 'Success',
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: false,
            fail_one: 'Failure',
            step_two: nil,
            step_three: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[OnErrorDoby handle_error step_two step_three] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: nil,
            fail_one: nil,
            step_two: 'Success',
            step_three: 'Success',
            handle_error: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when on_error to FAIL' do
    let(:action_block) { when_doby_on_error_to_fail }

    context 'when OnErrorDoby success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[OnErrorDoby step_two step_three] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: true,
            fail_one: nil,
            step_two: 'Success',
            step_three: 'Success',
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: false,
            fail_one: 'Failure',
            step_two: nil,
            step_three: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[OnErrorDoby handle_error fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: nil,
            fail_one: 'Failure',
            step_two: nil,
            step_three: nil,
            handle_error: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when doby on_error finish_him' do
    let(:action_block) { when_doby_on_error_finish_him }

    context 'when OnErrorDoby success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[OnErrorDoby step_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: true,
            step_one: 'Success',
            fail_one: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: false,
            step_one: nil,
            fail_one: 'Failure',
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[OnErrorDoby handle_error] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: nil,
            step_one: nil,
            fail_one: nil,
            handle_error: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when doby finish_him on_error' do
    let(:action_block) { when_doby_finish_him_on_error }

    context 'when OnErrorDoby success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[OnErrorDoby step_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: true,
            step_one: 'Success',
            fail_one: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: false,
            step_one: nil,
            fail_one: 'Failure',
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[OnErrorDoby handle_error] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            some_doby: nil,
            step_one: nil,
            fail_one: nil,
            handle_error: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when aide on_error to step' do
    let(:action_block) { when_aide_on_error_to_step }

    context 'when OnErrorDoby success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: true,
            fail_one: 'Failure',
            step_two: nil,
            pass_one: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: false,
            fail_one: 'Failure',
            step_two: nil,
            pass_one: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one OnErrorDoby handle_error pass_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: nil,
            fail_one: nil,
            step_two: nil,
            pass_one: 'Success',
            handle_error: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when aide on_error to PASS' do
    let(:action_block) { when_aide_on_error_to_pass }

    context 'when OnErrorDoby success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: true,
            fail_one: 'Failure',
            step_two: nil,
            pass_one: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: false,
            fail_one: 'Failure',
            step_two: nil,
            pass_one: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one OnErrorDoby handle_error step_two pass_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: nil,
            fail_one: nil,
            step_two: 'Success',
            pass_one: 'Success',
            handle_error: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when aide on_error to FAIL' do
    let(:action_block) { when_aide_on_error_to_fail }

    context 'when OnErrorDoby success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: true,
            fail_one: 'Failure',
            step_two: nil,
            pass_one: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: false,
            fail_one: 'Failure',
            step_two: nil,
            pass_one: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one OnErrorDoby handle_error fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: nil,
            fail_one: 'Failure',
            step_two: nil,
            pass_one: nil,
            handle_error: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when aide on_error finish_him' do
    let(:action_block) { when_aide_on_error_finish_him }

    context 'when OnErrorDoby success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: true,
            fail_one: 'Failure',
            step_two: nil,
            pass_one: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: false,
            fail_one: 'Failure',
            step_two: nil,
            pass_one: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one OnErrorDoby handle_error] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: nil,
            fail_one: nil,
            step_two: nil,
            pass_one: nil,
            handle_error: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when aide finish_him on_error' do
    let(:action_block) { when_aide_finish_him_on_error }

    context 'when OnErrorDoby success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: true,
            fail_one: 'Failure',
            step_two: nil,
            pass_one: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one OnErrorDoby fail_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: false,
            fail_one: 'Failure',
            step_two: nil,
            pass_one: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when OnErrorDoby raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }
      let(:railway_flow) { %i[step_one OnErrorDoby handle_error] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            some_doby: nil,
            fail_one: nil,
            step_two: nil,
            pass_one: nil,
            handle_error: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end
end
