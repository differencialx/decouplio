# frozen_string_literal: true

RSpec.describe 'Deny cases' do
  include_context 'with basic spec setup'

  let(:input_params) do
    {
      before_deny: before_deny,
      after_deny: after_deny,
      deny_result: deny_result,
      doby: doby,
      s1: s1,
      f1: f1,
      p1: p1,
      octo_key: octo_key,
      w1: w1
    }
  end

  let(:before_deny) { -> { true } }
  let(:after_deny) { -> { true } }
  let(:deny_result) { nil }
  let(:doby) { nil }
  let(:s1) { nil }
  let(:f1) { nil }
  let(:p1) { nil }
  let(:octo_key) { nil }
  let(:w1) { nil }

  context 'when before step as first step' do
    let(:action_block) { when_deny_before_step_as_first_step }

    context 'when raises an error' do
      let(:expected_message) do
        Decouplio::Const::Validations::Deny::FIRST_STEP
      end

      it 'raises error' do
        expect { action }.to raise_proper_error(
          Decouplio::Errors::DenyCanNotBeFirstStepError,
          expected_message
        )
      end
    end
  end

  context 'when before step' do
    let(:action_block) { when_deny_before_step }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one step_two] }
      let(:errors) { {} }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: 'Success',
            semantic: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one SemanticDeny] }
      let(:errors) do
        {
          bad_request: ['Deny message']
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
            semantic: :bad_request
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after step' do
    let(:action_block) { when_deny_after_step }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one step_two] }
      let(:errors) { {} }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: 'Success',
            semantic: nil,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one SemanticDeny fail_one] }
      let(:errors) do
        {
          bad_request: ['Deny message']
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
            semantic: :bad_request,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after step on_success on_failure to doby' do
    let(:action_block) { when_deny_after_step_on_success_on_failure_to_doby }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one SemanticDeny] }
      let(:errors) do
        {
          bad_request: ['Doby message']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: nil,
            semantic: :bad_request,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one SemanticDeny] }
      let(:errors) do
        {
          bad_request: ['Doby message']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: nil,
            semantic: :bad_request,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after step on_success on_failure to deny' do
    let(:action_block) { when_deny_after_step_on_success_on_failure_to_deny }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one SemanticDeny] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: nil,
            semantic: :bad_request,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one SemanticDeny] }
      let(:errors) do
        {
          bad_request: ['Deny message']
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
            semantic: :bad_request,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after step with PASS FAIL' do
    let(:action_block) { when_deny_after_step_pass_fail }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one SemanticDeny fail_one] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            step_two: nil,
            semantic: :bad_request,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one SemanticDeny step_two] }
      let(:errors) do
        {
          bad_request: ['Doby message']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            step_two: 'Success',
            semantic: :bad_request,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when before fail' do
    let(:action_block) { when_deny_before_fail }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one] }
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
            semantic: nil,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one SemanticDeny fail_one] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            semantic: :bad_request,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after fail' do
    let(:action_block) { when_deny_after_fail }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one] }
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
            semantic: nil,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one fail_one SemanticDeny] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            semantic: :bad_request,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after fail on_success on_failure to doby' do
    let(:action_block) { when_deny_after_fail_on_success_on_failure_to_doby }
    let(:s1) { -> { false } }

    context 'when step_one success' do
      let(:f1) { -> { true } }
      let(:railway_flow) { %i[step_one fail_one SemanticDeny] }
      let(:errors) do
        {
          bad_request: ['Doby message']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            semantic: :bad_request,
            fail_one: true
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:f1) { -> { false } }
      let(:railway_flow) { %i[step_one fail_one SemanticDeny] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            semantic: :bad_request,
            fail_one: false
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after fail on_success on_failure to deny' do
    let(:action_block) { when_deny_after_fail_on_success_on_failure_to_deny }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one SemanticDeny] }
      let(:errors) do
        {
          bad_request: ['Doby message']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            semantic: :bad_request,
            fail_one: nil,
            fail_two: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }

      context 'when fail_one success' do
        let(:f1) { -> { true } }
        let(:railway_flow) { %i[step_one fail_one fail_two SemanticDeny] }
        let(:errors) do
          {
            bad_request: ['Deny message']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: errors,
            state: {
              step_one: false,
              semantic: :bad_request,
              fail_one: true,
              fail_two: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when fail_one failure' do
        let(:f1) { -> { false } }
        let(:railway_flow) { %i[step_one fail_one SemanticDeny] }
        let(:errors) do
          {
            bad_request: ['Deny message']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: errors,
            state: {
              step_one: false,
              semantic: :bad_request,
              fail_one: false,
              fail_two: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end
  end

  context 'when after afil PASS FAIL' do
    let(:action_block) { when_deny_after_fail_pass_fail }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one SemanticDeny] }
      let(:errors) do
        {
          bad_request: ['Doby message']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: true,
            semantic: :bad_request,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }

      context 'when fail_one success' do
        let(:f1) { -> { true } }
        let(:railway_flow) { %i[step_one fail_one SemanticDeny] }
        let(:errors) do
          {
            bad_request: ['Deny message']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: errors,
            state: {
              step_one: false,
              semantic: :bad_request,
              fail_one: true
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when fail_one failure' do
        let(:f1) { -> { false } }
        let(:railway_flow) { %i[step_one fail_one SemanticDeny] }
        let(:errors) do
          {
            bad_request: ['Doby message']
          }
        end
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: errors,
            state: {
              step_one: false,
              semantic: :bad_request,
              fail_one: false
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end
  end

  context 'when before pass' do
    let(:action_block) { when_deny_before_pass }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one pass_one] }
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
            semantic: nil,
            pass_one: 'Success'
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one SemanticDeny] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            semantic: :bad_request,
            pass_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after_pass' do
    let(:action_block) { when_deny_after_pass }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one pass_one] }
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
            semantic: nil,
            pass_one: 'Success'
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one SemanticDeny] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            semantic: :bad_request,
            pass_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when before octo' do
    let(:action_block) { when_deny_before_octo }
    let(:octo_key) { :octo1 }
    let(:p1) { -> { true } }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one octo_name palp_step_one step_two] }
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
            palp_step_one: true,
            step_two: 'Success',
            octo_key: octo_key,
            fail_one: nil,
            semantic: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one SemanticDeny fail_one] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            palp_step_one: nil,
            step_two: nil,
            octo_key: octo_key,
            fail_one: 'Failure',
            semantic: :bad_request
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after octo' do
    let(:action_block) { when_deny_after_octo }
    let(:octo_key) { :octo1 }

    context 'when palp_step_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[octo_name palp_step_one step_one] }
      let(:errors) do
        {}
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: 'Success',
            palp_step_one: true,
            octo_key: octo_key,
            fail_one: nil,
            semantic: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_step_one failure' do
      let(:p1) { -> { false } }
      let(:railway_flow) { %i[octo_name palp_step_one SemanticDeny fail_one] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            palp_step_one: false,
            octo_key: octo_key,
            fail_one: 'Failure',
            semantic: :bad_request
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after octo on_success on_failure to doby' do
    let(:action_block) { when_deny_after_octo_on_success_on_failure_to_doby }
    let(:octo_key) { :octo1 }

    context 'when palp_step_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[octo_name palp_step_one SemanticDeny] }
      let(:errors) do
        {
          bad_request: ['Doby message']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            palp_step_one: true,
            octo_key: octo_key,
            fail_one: nil,
            semantic: :bad_request
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_step_one failure' do
      let(:p1) { -> { false } }
      let(:railway_flow) { %i[octo_name palp_step_one SemanticDeny] }
      let(:errors) do
        {
          bad_request: ['Doby message']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            palp_step_one: false,
            octo_key: octo_key,
            fail_one: nil,
            semantic: :bad_request
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when aafter octo on_success on_failure to deny' do
    let(:action_block) { when_deny_after_octo_on_success_on_failure_to_deny }
    let(:octo_key) { :octo1 }

    context 'when palp_step_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[octo_name palp_step_one SemanticDeny fail_one] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            palp_step_one: true,
            octo_key: octo_key,
            fail_one: 'Failure',
            semantic: :bad_request
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_step_one failure' do
      let(:p1) { -> { false } }
      let(:railway_flow) { %i[octo_name palp_step_one SemanticDeny fail_one] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            palp_step_one: false,
            octo_key: octo_key,
            fail_one: 'Failure',
            semantic: :bad_request
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after octo PASS FAIL' do
    let(:action_block) { when_deny_after_octo_pass_fail }
    let(:octo_key) { :octo1 }

    context 'when palp_step_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[octo_name palp_step_one SemanticDeny fail_one] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            palp_step_one: true,
            octo_key: octo_key,
            fail_one: 'Failure',
            semantic: :bad_request
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_step_one failure' do
      let(:p1) { -> { false } }
      let(:railway_flow) { %i[octo_name palp_step_one SemanticDeny step_one] }
      let(:errors) do
        {
          bad_request: ['Doby message']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: 'Success',
            palp_step_one: false,
            octo_key: octo_key,
            fail_one: nil,
            semantic: :bad_request
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when inside palp' do
    let(:action_block) { when_deny_inside_palp }
    let(:octo_key) { :octo1 }

    context 'when palp_step_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[octo_name palp_step_one SemanticDeny fail_one] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: nil,
            palp_step_one: true,
            octo_key: octo_key,
            fail_one: 'Failure',
            semantic: :bad_request
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when palp_step_one failure' do
      let(:p1) { -> { false } }
      let(:railway_flow) { %i[octo_name palp_step_one SemanticDeny step_one] }
      let(:errors) do
        {
          bad_request: ['Doby message']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: 'Success',
            palp_step_one: false,
            octo_key: octo_key,
            fail_one: nil,
            semantic: :bad_request
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when with resq' do
    let(:action_block) { when_deny_with_resq }
    let(:error_message) { 'ArgumentError message' }

    context 'when step_one success' do
      let(:s1) { -> { true } }

      context 'when RandomDoby success' do
        let(:doby) { -> { true } }
        let(:railway_flow) do
          %i[
            step_one
            RandomDoby
            step_two
          ]
        end
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
              handler_one: nil,
              semantic: nil,
              handler_deny_semantic: nil,
              handler_deny_resolve: nil,
              result: nil,
              random: true,
              step_two: 'Success',
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when RandomDoby failure' do
        let(:doby) { -> { false } }

        context 'when ResolveDeny success' do
          let(:deny_result) { -> { true } }
          let(:railway_flow) do
            %i[
              step_one
              RandomDoby
              ResolveDeny
              fail_one
            ]
          end
          let(:errors) do
            {}
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: true,
                handler_one: nil,
                semantic: nil,
                handler_deny_semantic: nil,
                handler_deny_resolve: nil,
                result: true,
                random: false,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveDeny failure' do
          let(:deny_result) { -> { false } }
          let(:railway_flow) do
            %i[
              step_one
              RandomDoby
              ResolveDeny
              fail_one
            ]
          end
          let(:errors) do
            {}
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: true,
                handler_one: nil,
                semantic: nil,
                handler_deny_semantic: nil,
                handler_deny_resolve: nil,
                result: false,
                random: false,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveDeny raises an error' do
          let(:deny_result) { -> { raise ArgumentError, error_message } }
          let(:railway_flow) do
            %i[
              step_one
              RandomDoby
              ResolveDeny
              handler_deny_resolve
              fail_one
            ]
          end
          let(:errors) do
            {}
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: true,
                handler_one: nil,
                semantic: nil,
                handler_deny_semantic: nil,
                handler_deny_resolve: error_message,
                result: nil,
                random: false,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }

      context 'when SemanticDeny success' do
        let(:after_deny) { -> { true } }

        context 'when ResolveDeny success' do
          let(:deny_result) { -> { true } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticDeny
              ResolveDeny
              fail_one
            ]
          end
          let(:errors) do
            {
              server_error: ['Something went wrong']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: false,
                handler_one: nil,
                semantic: :server_error,
                handler_deny_semantic: nil,
                handler_deny_resolve: nil,
                result: true,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveDeny failure' do
          let(:deny_result) { -> { false } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticDeny
              ResolveDeny
              fail_one
            ]
          end
          let(:errors) do
            {
              server_error: ['Something went wrong']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: false,
                handler_one: nil,
                semantic: :server_error,
                handler_deny_semantic: nil,
                handler_deny_resolve: nil,
                result: false,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveDeny raises an error' do
          let(:deny_result) { -> { raise ArgumentError, error_message } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticDeny
              ResolveDeny
              handler_deny_resolve
              fail_one
            ]
          end
          let(:errors) do
            {
              server_error: ['Something went wrong']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: false,
                handler_one: nil,
                semantic: :server_error,
                handler_deny_semantic: nil,
                handler_deny_resolve: error_message,
                result: nil,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when SemanticDeny failure' do
        let(:after_deny) { -> { false } }

        context 'when ResolveDeny success' do
          let(:deny_result) { -> { true } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticDeny
              ResolveDeny
              fail_one
            ]
          end
          let(:errors) do
            {
              server_error: ['Something went wrong']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: false,
                handler_one: nil,
                semantic: :server_error,
                handler_deny_semantic: nil,
                handler_deny_resolve: nil,
                result: true,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveDeny failure' do
          let(:deny_result) { -> { false } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticDeny
              ResolveDeny
              fail_one
            ]
          end
          let(:errors) do
            {
              server_error: ['Something went wrong']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: false,
                handler_one: nil,
                semantic: :server_error,
                handler_deny_semantic: nil,
                handler_deny_resolve: nil,
                result: false,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveDeny raises an error' do
          let(:deny_result) { -> { raise ArgumentError, error_message } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticDeny
              ResolveDeny
              handler_deny_resolve
              fail_one
            ]
          end
          let(:errors) do
            {
              server_error: ['Something went wrong']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: false,
                handler_one: nil,
                semantic: :server_error,
                handler_deny_semantic: nil,
                handler_deny_resolve: error_message,
                result: nil,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when SemanticDeny raises an error' do
        let(:before_deny) { -> { raise ArgumentError, error_message } }

        context 'when ResolveDeny success' do
          let(:deny_result) { -> { true } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticDeny
              handler_deny_semantic
              ResolveDeny
              fail_one
            ]
          end
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
                handler_one: nil,
                semantic: nil,
                handler_deny_semantic: error_message,
                handler_deny_resolve: nil,
                result: true,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveDeny failure' do
          let(:deny_result) { -> { false } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticDeny
              handler_deny_semantic
              ResolveDeny
              fail_one
            ]
          end
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
                handler_one: nil,
                semantic: nil,
                handler_deny_semantic: error_message,
                handler_deny_resolve: nil,
                result: false,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveDeny raises an error' do
          let(:deny_result) { -> { raise ArgumentError, error_message } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticDeny
              handler_deny_semantic
              ResolveDeny
              handler_deny_resolve
              fail_one
            ]
          end
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
                handler_one: nil,
                semantic: nil,
                handler_deny_semantic: error_message,
                handler_deny_resolve: error_message,
                result: nil,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end
    end

    context 'when step_one raises an error' do
      let(:s1) { -> { raise ArgumentError, error_message } }

      context 'when SemanticDeny success' do
        let(:after_deny) { -> { true } }

        context 'when ResolveDeny success' do
          let(:deny_result) { -> { true } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticDeny
              ResolveDeny
              fail_one
            ]
          end
          let(:errors) do
            {
              server_error: ['Something went wrong']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: nil,
                handler_one: error_message,
                semantic: :server_error,
                handler_deny_semantic: nil,
                handler_deny_resolve: nil,
                result: true,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveDeny failure' do
          let(:deny_result) { -> { false } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticDeny
              ResolveDeny
              fail_one
            ]
          end
          let(:errors) do
            {
              server_error: ['Something went wrong']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: nil,
                handler_one: error_message,
                semantic: :server_error,
                handler_deny_semantic: nil,
                handler_deny_resolve: nil,
                result: false,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveDeny raises an error' do
          let(:deny_result) { -> { raise ArgumentError, error_message } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticDeny
              ResolveDeny
              handler_deny_resolve
              fail_one
            ]
          end
          let(:errors) do
            {
              server_error: ['Something went wrong']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: nil,
                handler_one: error_message,
                semantic: :server_error,
                handler_deny_semantic: nil,
                handler_deny_resolve: error_message,
                result: nil,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when SemanticDeny failure' do
        let(:after_deny) { -> { false } }

        context 'when ResolveDeny success' do
          let(:deny_result) { -> { true } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticDeny
              ResolveDeny
              fail_one
            ]
          end
          let(:errors) do
            {
              server_error: ['Something went wrong']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: nil,
                handler_one: error_message,
                semantic: :server_error,
                handler_deny_semantic: nil,
                handler_deny_resolve: nil,
                result: true,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveDeny failure' do
          let(:deny_result) { -> { false } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticDeny
              ResolveDeny
              fail_one
            ]
          end
          let(:errors) do
            {
              server_error: ['Something went wrong']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: nil,
                handler_one: error_message,
                semantic: :server_error,
                handler_deny_semantic: nil,
                handler_deny_resolve: nil,
                result: false,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveDeny raises an error' do
          let(:deny_result) { -> { raise ArgumentError, error_message } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticDeny
              ResolveDeny
              handler_deny_resolve
              fail_one
            ]
          end
          let(:errors) do
            {
              server_error: ['Something went wrong']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: nil,
                handler_one: error_message,
                semantic: :server_error,
                handler_deny_semantic: nil,
                handler_deny_resolve: error_message,
                result: nil,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when SemanticDeny raises an error' do
        let(:before_deny) { -> { raise ArgumentError, error_message } }

        context 'when ResolveDeny success' do
          let(:deny_result) { -> { true } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticDeny
              handler_deny_semantic
              ResolveDeny
              fail_one
            ]
          end
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
                handler_one: error_message,
                semantic: nil,
                handler_deny_semantic: error_message,
                handler_deny_resolve: nil,
                result: true,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveDeny failure' do
          let(:deny_result) { -> { false } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticDeny
              handler_deny_semantic
              ResolveDeny
              fail_one
            ]
          end
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
                handler_one: error_message,
                semantic: nil,
                handler_deny_semantic: error_message,
                handler_deny_resolve: nil,
                result: false,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveDeny raises an error' do
          let(:deny_result) { -> { raise ArgumentError, error_message } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticDeny
              handler_deny_semantic
              ResolveDeny
              handler_deny_resolve
              fail_one
            ]
          end
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
                handler_one: error_message,
                semantic: nil,
                handler_deny_semantic: error_message,
                handler_deny_resolve: error_message,
                result: nil,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end
    end
  end

  context 'when before wrap' do
    let(:action_block) { when_deny_before_wrap }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:w1) { -> { true } }
      let(:railway_flow) { %i[step_one some_wrap wrap_step_one] }
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
            wrap_step_one: true,
            semantic: nil,
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one SemanticDeny fail_one] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            wrap_step_one: nil,
            semantic: :bad_request,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after wrap' do
    let(:action_block) { when_deny_after_wrap }

    context 'when step_one success' do
      let(:s1) { -> { true } }

      context 'when wrap_step_one success' do
        let(:w1) { -> { true } }
        let(:railway_flow) do
          %i[
            step_one
            some_wrap
            wrap_step_one
            step_two
          ]
        end
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
              wrap_step_one: true,
              semantic: nil,
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when wrap_step_one failure' do
        let(:w1) { -> { false } }
        let(:railway_flow) do
          %i[
            step_one
            some_wrap
            wrap_step_one
            SemanticDeny
            fail_one
          ]
        end
        let(:errors) do
          {
            bad_request: ['Deny message']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: errors,
            state: {
              step_one: true,
              wrap_step_one: false,
              semantic: :bad_request,
              fail_one: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one SemanticDeny fail_one] }
      let(:errors) do
        {
          bad_request: ['Deny message']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: errors,
          state: {
            step_one: false,
            wrap_step_one: nil,
            semantic: :bad_request,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after wrap on_success on_failure to doby' do
    let(:action_block) { when_deny_after_wrap_on_success_on_failure_to_doby }

    context 'when step_one success' do
      let(:s1) { -> { true } }

      context 'when some_wrap success' do
        let(:w1) { -> { true } }

        context 'when SemanticDoby success' do
          let(:after_deny) { -> { true } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticDeny step_two] }
          let(:errors) do
            {
              bad_request: ['Doby message']
            }
          end
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: true,
                step_two: 'Success',
                wrap_step_one: true,
                semantic: :bad_request,
                fail_one: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when SemanticDoby failure' do
          let(:after_deny) { -> { false } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticDeny SemanticDeny fail_one] }
          let(:errors) do
            {
              bad_request: ['Doby message', 'Deny message']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: true,
                step_two: nil,
                wrap_step_one: true,
                semantic: :bad_request,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when some_wrap failure' do
        let(:w1) { -> { false } }

        context 'when SemanticDoby success' do
          let(:after_deny) { -> { true } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticDeny step_two] }
          let(:errors) do
            {
              bad_request: ['Doby message']
            }
          end
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: true,
                step_two: 'Success',
                wrap_step_one: false,
                semantic: :bad_request,
                fail_one: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when SemanticDoby failure' do
          let(:after_deny) { -> { false } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticDeny SemanticDeny fail_one] }
          let(:errors) do
            {
              bad_request: ['Doby message', 'Deny message']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: true,
                step_two: nil,
                wrap_step_one: false,
                semantic: :bad_request,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one SemanticDeny fail_one] }
      let(:errors) do
        {
          bad_request: ['Deny message']
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
            wrap_step_one: nil,
            semantic: :bad_request,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after wrap on_success on_failure to deny' do
    let(:action_block) { when_deny_after_wrap_on_success_on_failure_to_deny }

    context 'when step_one success' do
      let(:s1) { -> { true } }

      context 'when some_wrap success' do
        let(:w1) { -> { true } }
        let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticDeny fail_one] }
        let(:errors) do
          {
            bad_request: ['Deny message']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: errors,
            state: {
              step_one: true,
              step_two: nil,
              wrap_step_one: true,
              semantic: :bad_request,
              fail_one: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when some_wrap failure' do
        let(:w1) { -> { false } }
        let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticDeny fail_one] }
        let(:errors) do
          {
            bad_request: ['Deny message']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: errors,
            state: {
              step_one: true,
              step_two: nil,
              wrap_step_one: false,
              semantic: :bad_request,
              fail_one: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one SemanticDeny fail_one] }
      let(:errors) do
        {
          bad_request: ['Deny message']
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
            wrap_step_one: nil,
            semantic: :bad_request,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when after wrap PASS FAIL' do
    let(:action_block) { when_deny_after_wrap_pass_fail }

    context 'when step_one success' do
      let(:s1) { -> { true } }

      context 'when some_wrap success' do
        let(:w1) { -> { true } }
        let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticDeny fail_one] }
        let(:errors) do
          {
            bad_request: ['Deny message']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: errors,
            state: {
              step_one: true,
              step_two: nil,
              wrap_step_one: true,
              semantic: :bad_request,
              fail_one: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when some_wrap_failure' do
        let(:w1) { -> { false } }

        context 'when SemanticDoby success' do
          let(:after_deny) { -> { true } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticDeny step_two] }
          let(:errors) do
            {
              bad_request: ['Doby message']
            }
          end
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: true,
                step_two: 'Success',
                wrap_step_one: false,
                semantic: :bad_request,
                fail_one: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when SemanticDoby failure' do
          let(:after_deny) { -> { false } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticDeny SemanticDeny fail_one] }
          let(:errors) do
            {
              bad_request: ['Doby message', 'Deny message']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: true,
                step_two: nil,
                wrap_step_one: false,
                semantic: :bad_request,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:railway_flow) { %i[step_one SemanticDeny fail_one] }
      let(:errors) do
        {
          bad_request: ['Deny message']
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
            wrap_step_one: nil,
            semantic: :bad_request,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when inside wrap' do
    let(:action_block) { when_deny_inside_wrap }

    context 'when step_one success' do
      let(:s1) { -> { true } }

      context 'when wrap_step_one success' do
        let(:w1) { -> { true } }

        context 'when SemanticDoby success' do
          let(:after_deny) { -> { true } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticDeny step_two] }
          let(:errors) do
            {
              bad_request: ['Doby message']
            }
          end
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: true,
                step_two: 'Success',
                wrap_step_one: true,
                semantic: :bad_request,
                fail_one: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when SemanticDoby failure' do
          let(:after_deny) { -> { false } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticDeny SemanticDeny fail_one] }
          let(:errors) do
            {
              bad_request: ['Doby message', 'Deny message']
            }
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: errors,
              state: {
                step_one: true,
                step_two: nil,
                wrap_step_one: true,
                semantic: :bad_request,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when wrap_step_one failure' do
        let(:w1) { -> { false } }
        let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticDeny fail_one] }
        let(:errors) do
          {
            bad_request: ['Deny message']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: errors,
            state: {
              step_one: true,
              step_two: nil,
              wrap_step_one: false,
              semantic: :bad_request,
              fail_one: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end
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
            wrap_step_one: nil,
            semantic: nil,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end
end
