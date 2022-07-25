# frozen_string_literal: true

RSpec.describe 'Fail as Aide cases' do
  include_context 'with basic spec setup'

  let(:input_params) do
    {
      before_aide: before_aide,
      after_aide: after_aide,
      aide_result: aide_result,
      doby: doby,
      s1: s1,
      f1: f1,
      p1: p1,
      octo_key: octo_key,
      w1: w1,
      aide: aide,
      condition: condition
    }
  end

  let(:before_aide) { -> { true } }
  let(:after_aide) { -> { true } }
  let(:aide_result) { nil }
  let(:doby) { nil }
  let(:s1) { nil }
  let(:f1) { nil }
  let(:p1) { nil }
  let(:octo_key) { nil }
  let(:w1) { nil }
  let(:aide) { nil }
  let(:condition) { nil }

  context 'when before step as first step' do
    let(:action_block) { when_fail_as_aide_before_step_as_first_step }

    context 'when raises an error' do
      let(:expected_message) do
        Decouplio::Const::Validations::Fail::FIRST_STEP
      end

      it 'raises error' do
        expect { action }.to raise_proper_error(
          Decouplio::Errors::FailCanNotBeFirstStepError,
          expected_message
        )
      end
    end
  end

  context 'when before step' do
    let(:action_block) { when_fail_as_aide_before_step }

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
      let(:railway_flow) { %i[step_one SemanticFailAsAide] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_after_step }

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
      let(:railway_flow) { %i[step_one SemanticFailAsAide fail_one] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_after_step_on_success_on_failure_to_doby }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one SemanticFailAsAide] }
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
      let(:railway_flow) { %i[step_one SemanticFailAsAide] }
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

  context 'when after step on_success on_failure to aide' do
    let(:action_block) { when_fail_as_aide_after_step_on_success_on_failure_to_aide }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one SemanticFailAsAide] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
      let(:railway_flow) { %i[step_one SemanticFailAsAide] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_after_step_pass_fail }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one SemanticFailAsAide fail_one] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
      let(:railway_flow) { %i[step_one SemanticFailAsAide step_two] }
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
    let(:action_block) { when_fail_as_aide_before_fail }

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
      let(:railway_flow) { %i[step_one SemanticFailAsAide fail_one] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_after_fail }

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
      let(:railway_flow) { %i[step_one fail_one SemanticFailAsAide] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_after_fail_on_success_on_failure_to_doby }
    let(:s1) { -> { false } }

    context 'when step_one success' do
      let(:f1) { -> { true } }
      let(:railway_flow) { %i[step_one fail_one SemanticFailAsAide] }
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
      let(:railway_flow) { %i[step_one fail_one SemanticFailAsAide] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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

  context 'when after fail on_success on_failure to aide' do
    let(:action_block) { when_fail_as_aide_after_fail_on_success_on_failure_to_aide }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one SemanticFailAsAide] }
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
        let(:railway_flow) { %i[step_one fail_one fail_two SemanticFailAsAide] }
        let(:errors) do
          {
            bad_request: ['Aide message']
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
        let(:railway_flow) { %i[step_one fail_one SemanticFailAsAide] }
        let(:errors) do
          {
            bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_after_fail_pass_fail }

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:railway_flow) { %i[step_one SemanticFailAsAide] }
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
        let(:railway_flow) { %i[step_one fail_one SemanticFailAsAide] }
        let(:errors) do
          {
            bad_request: ['Aide message']
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
        let(:railway_flow) { %i[step_one fail_one SemanticFailAsAide] }
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
    let(:action_block) { when_fail_as_aide_before_pass }

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
      let(:railway_flow) { %i[step_one SemanticFailAsAide] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_after_pass }

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
      let(:railway_flow) { %i[step_one SemanticFailAsAide] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_before_octo }
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
      let(:railway_flow) { %i[step_one SemanticFailAsAide fail_one] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_after_octo }
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
      let(:railway_flow) { %i[octo_name palp_step_one SemanticFailAsAide fail_one] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_after_octo_on_success_on_failure_to_doby }
    let(:octo_key) { :octo1 }

    context 'when palp_step_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[octo_name palp_step_one SemanticFailAsAide] }
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
      let(:railway_flow) { %i[octo_name palp_step_one SemanticFailAsAide] }
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

  context 'when aafter octo on_success on_failure to aide' do
    let(:action_block) { when_fail_as_aide_after_octo_on_success_on_failure_to_aide }
    let(:octo_key) { :octo1 }

    context 'when palp_step_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[octo_name palp_step_one SemanticFailAsAide fail_one] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
      let(:railway_flow) { %i[octo_name palp_step_one SemanticFailAsAide fail_one] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_after_octo_pass_fail }
    let(:octo_key) { :octo1 }

    context 'when palp_step_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[octo_name palp_step_one SemanticFailAsAide fail_one] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
      let(:railway_flow) { %i[octo_name palp_step_one SemanticFailAsAide step_one] }
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
    let(:action_block) { when_fail_as_aide_inside_palp }
    let(:octo_key) { :octo1 }

    context 'when palp_step_one success' do
      let(:p1) { -> { true } }
      let(:railway_flow) { %i[octo_name palp_step_one SemanticFailAsAide fail_one] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
      let(:railway_flow) { %i[octo_name palp_step_one SemanticFailAsAide step_one] }
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
    let(:action_block) { when_fail_as_aide_with_resq }
    let(:error_message) { 'ArgumentError message' }

    context 'when step_one success' do
      let(:s1) { -> { true } }

      context 'when RandomStepAsDoby success' do
        let(:doby) { -> { true } }
        let(:railway_flow) do
          %i[
            step_one
            RandomStepAsDoby
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
              handler_aide_semantic: nil,
              handler_aide_resolve: nil,
              result: nil,
              random: true,
              step_two: 'Success',
              fail_one: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when RandomStepAsDoby failure' do
        let(:doby) { -> { false } }

        context 'when ResolveFailAsAide success' do
          let(:aide_result) { -> { true } }
          let(:railway_flow) do
            %i[
              step_one
              RandomStepAsDoby
              ResolveFailAsAide
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
                handler_aide_semantic: nil,
                handler_aide_resolve: nil,
                result: true,
                random: false,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveFailAsAide failure' do
          let(:aide_result) { -> { false } }
          let(:railway_flow) do
            %i[
              step_one
              RandomStepAsDoby
              ResolveFailAsAide
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
                handler_aide_semantic: nil,
                handler_aide_resolve: nil,
                result: false,
                random: false,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveFailAsAide raises an error' do
          let(:aide_result) { -> { raise ArgumentError, error_message } }
          let(:railway_flow) do
            %i[
              step_one
              RandomStepAsDoby
              ResolveFailAsAide
              handler_aide_resolve
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
                handler_aide_semantic: nil,
                handler_aide_resolve: error_message,
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

      context 'when SemanticFailAsAide success' do
        let(:after_aide) { -> { true } }

        context 'when ResolveFailAsAide success' do
          let(:aide_result) { -> { true } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticFailAsAide
              ResolveFailAsAide
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
                handler_aide_semantic: nil,
                handler_aide_resolve: nil,
                result: true,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveFailAsAide failure' do
          let(:aide_result) { -> { false } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticFailAsAide
              ResolveFailAsAide
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
                handler_aide_semantic: nil,
                handler_aide_resolve: nil,
                result: false,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveFailAsAide raises an error' do
          let(:aide_result) { -> { raise ArgumentError, error_message } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticFailAsAide
              ResolveFailAsAide
              handler_aide_resolve
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
                handler_aide_semantic: nil,
                handler_aide_resolve: error_message,
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

      context 'when SemanticFailAsAide failure' do
        let(:after_aide) { -> { false } }

        context 'when ResolveFailAsAide success' do
          let(:aide_result) { -> { true } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticFailAsAide
              ResolveFailAsAide
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
                handler_aide_semantic: nil,
                handler_aide_resolve: nil,
                result: true,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveFailAsAide failure' do
          let(:aide_result) { -> { false } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticFailAsAide
              ResolveFailAsAide
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
                handler_aide_semantic: nil,
                handler_aide_resolve: nil,
                result: false,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveFailAsAide raises an error' do
          let(:aide_result) { -> { raise ArgumentError, error_message } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticFailAsAide
              ResolveFailAsAide
              handler_aide_resolve
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
                handler_aide_semantic: nil,
                handler_aide_resolve: error_message,
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

      context 'when SemanticFailAsAide raises an error' do
        let(:before_aide) { -> { raise ArgumentError, error_message } }

        context 'when ResolveFailAsAide success' do
          let(:aide_result) { -> { true } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticFailAsAide
              handler_aide_semantic
              ResolveFailAsAide
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
                handler_aide_semantic: error_message,
                handler_aide_resolve: nil,
                result: true,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveFailAsAide failure' do
          let(:aide_result) { -> { false } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticFailAsAide
              handler_aide_semantic
              ResolveFailAsAide
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
                handler_aide_semantic: error_message,
                handler_aide_resolve: nil,
                result: false,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveFailAsAide raises an error' do
          let(:aide_result) { -> { raise ArgumentError, error_message } }
          let(:railway_flow) do
            %i[
              step_one
              SemanticFailAsAide
              handler_aide_semantic
              ResolveFailAsAide
              handler_aide_resolve
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
                handler_aide_semantic: error_message,
                handler_aide_resolve: error_message,
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

      context 'when SemanticFailAsAide success' do
        let(:after_aide) { -> { true } }

        context 'when ResolveFailAsAide success' do
          let(:aide_result) { -> { true } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticFailAsAide
              ResolveFailAsAide
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
                handler_aide_semantic: nil,
                handler_aide_resolve: nil,
                result: true,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveFailAsAide failure' do
          let(:aide_result) { -> { false } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticFailAsAide
              ResolveFailAsAide
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
                handler_aide_semantic: nil,
                handler_aide_resolve: nil,
                result: false,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveFailAsAide raises an error' do
          let(:aide_result) { -> { raise ArgumentError, error_message } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticFailAsAide
              ResolveFailAsAide
              handler_aide_resolve
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
                handler_aide_semantic: nil,
                handler_aide_resolve: error_message,
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

      context 'when SemanticFailAsAide failure' do
        let(:after_aide) { -> { false } }

        context 'when ResolveFailAsAide success' do
          let(:aide_result) { -> { true } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticFailAsAide
              ResolveFailAsAide
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
                handler_aide_semantic: nil,
                handler_aide_resolve: nil,
                result: true,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveFailAsAide failure' do
          let(:aide_result) { -> { false } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticFailAsAide
              ResolveFailAsAide
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
                handler_aide_semantic: nil,
                handler_aide_resolve: nil,
                result: false,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveFailAsAide raises an error' do
          let(:aide_result) { -> { raise ArgumentError, error_message } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticFailAsAide
              ResolveFailAsAide
              handler_aide_resolve
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
                handler_aide_semantic: nil,
                handler_aide_resolve: error_message,
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

      context 'when SemanticFailAsAide raises an error' do
        let(:before_aide) { -> { raise ArgumentError, error_message } }

        context 'when ResolveFailAsAide success' do
          let(:aide_result) { -> { true } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticFailAsAide
              handler_aide_semantic
              ResolveFailAsAide
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
                handler_aide_semantic: error_message,
                handler_aide_resolve: nil,
                result: true,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveFailAsAide failure' do
          let(:aide_result) { -> { false } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticFailAsAide
              handler_aide_semantic
              ResolveFailAsAide
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
                handler_aide_semantic: error_message,
                handler_aide_resolve: nil,
                result: false,
                random: nil,
                step_two: nil,
                fail_one: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when ResolveFailAsAide raises an error' do
          let(:aide_result) { -> { raise ArgumentError, error_message } }
          let(:railway_flow) do
            %i[
              step_one
              handler_one
              SemanticFailAsAide
              handler_aide_semantic
              ResolveFailAsAide
              handler_aide_resolve
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
                handler_aide_semantic: error_message,
                handler_aide_resolve: error_message,
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
    let(:action_block) { when_fail_as_aide_before_wrap }

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
      let(:railway_flow) { %i[step_one SemanticFailAsAide fail_one] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_after_wrap }

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
            SemanticFailAsAide
            fail_one
          ]
        end
        let(:errors) do
          {
            bad_request: ['Aide message']
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
      let(:railway_flow) { %i[step_one SemanticFailAsAide fail_one] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_after_wrap_on_success_on_failure_to_doby }

    context 'when step_one success' do
      let(:s1) { -> { true } }

      context 'when some_wrap success' do
        let(:w1) { -> { true } }

        context 'when SemanticDoby success' do
          let(:after_aide) { -> { true } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticFailAsAide step_two] }
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
          let(:after_aide) { -> { false } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticFailAsAide SemanticFailAsAide fail_one] }
          let(:errors) do
            {
              bad_request: ['Doby message', 'Aide message']
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
          let(:after_aide) { -> { true } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticFailAsAide step_two] }
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
          let(:after_aide) { -> { false } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticFailAsAide SemanticFailAsAide fail_one] }
          let(:errors) do
            {
              bad_request: ['Doby message', 'Aide message']
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
      let(:railway_flow) { %i[step_one SemanticFailAsAide fail_one] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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

  context 'when after wrap on_success on_failure to aide' do
    let(:action_block) { when_fail_as_aide_after_wrap_on_success_on_failure_to_aide }

    context 'when step_one success' do
      let(:s1) { -> { true } }

      context 'when some_wrap success' do
        let(:w1) { -> { true } }
        let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticFailAsAide fail_one] }
        let(:errors) do
          {
            bad_request: ['Aide message']
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
        let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticFailAsAide fail_one] }
        let(:errors) do
          {
            bad_request: ['Aide message']
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
      let(:railway_flow) { %i[step_one SemanticFailAsAide fail_one] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_after_wrap_pass_fail }

    context 'when step_one success' do
      let(:s1) { -> { true } }

      context 'when some_wrap success' do
        let(:w1) { -> { true } }
        let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticFailAsAide fail_one] }
        let(:errors) do
          {
            bad_request: ['Aide message']
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
          let(:after_aide) { -> { true } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticFailAsAide step_two] }
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
          let(:after_aide) { -> { false } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticFailAsAide SemanticFailAsAide fail_one] }
          let(:errors) do
            {
              bad_request: ['Doby message', 'Aide message']
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
      let(:railway_flow) { %i[step_one SemanticFailAsAide fail_one] }
      let(:errors) do
        {
          bad_request: ['Aide message']
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
    let(:action_block) { when_fail_as_aide_inside_wrap }

    context 'when step_one success' do
      let(:s1) { -> { true } }

      context 'when wrap_step_one success' do
        let(:w1) { -> { true } }

        context 'when SemanticDoby success' do
          let(:after_aide) { -> { true } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticFailAsAide step_two] }
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
          let(:after_aide) { -> { false } }
          let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticFailAsAide SemanticFailAsAide fail_one] }
          let(:errors) do
            {
              bad_request: ['Doby message', 'Aide message']
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
        let(:railway_flow) { %i[step_one some_wrap wrap_step_one SemanticFailAsAide fail_one] }
        let(:errors) do
          {
            bad_request: ['Aide message']
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

  context 'when on_success on_failure to steps' do
    let(:action_block) { when_fail_as_aide_on_success_on_failure_to_steps }
    let(:s1) { -> { false } }

    context 'when aide success' do
      let(:aide) { -> { true } }
      let(:railway_flow) { %i[step_one ForkFailAsAide fail_one] }
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
            result: 'Result'
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when aide failure' do
      let(:aide) { -> { false } }
      let(:railway_flow) { %i[step_one ForkFailAsAide step_two] }
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
            result: 'Result'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when on_success on_failure PASS FAIL' do
    let(:action_block) { when_fail_as_aide_on_success_on_failure_pass_fail }
    let(:s1) { -> { false } }

    context 'when aide success' do
      let(:aide) { -> { true } }
      let(:railway_flow) { %i[step_one ForkFailAsAide fail_one] }
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
            result: 'Result'
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when aide faailre' do
      let(:aide) { -> { false } }
      let(:railway_flow) { %i[step_one ForkFailAsAide step_two] }
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
            result: 'Result'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when on_success finish_him' do
    let(:action_block) { when_fail_as_aide_on_success_finish_him }
    let(:s1) { -> { false } }

    context 'when aide success' do
      let(:aide) { -> { true } }
      let(:railway_flow) { %i[step_one ForkFailAsAide] }
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
            result: 'Result'
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when aide failure' do
      let(:aide) { -> { false } }
      let(:railway_flow) { %i[step_one ForkFailAsAide fail_one] }
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
            result: 'Result'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when on_failure finish_him' do
    let(:action_block) { when_fail_as_aide_on_failure_finish_him }
    let(:s1) { -> { false } }

    context 'when aide success' do
      let(:aide) { -> { true } }
      let(:railway_flow) { %i[step_one ForkFailAsAide fail_one] }
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
            result: 'Result'
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when aide failure' do
      let(:aide) { -> { false } }
      let(:railway_flow) { %i[step_one ForkFailAsAide] }
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
            result: 'Result'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when finish_him true' do
    let(:action_block) { when_fail_as_aide_finish_him_true }
    let(:s1) { -> { false } }

    context 'when aide true' do
      let(:aide) { -> { true } }
      let(:railway_flow) { %i[step_one ForkFailAsAide] }
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
            result: 'Result'
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when aide false' do
      let(:aide) { -> { false } }
      let(:railway_flow) { %i[step_one ForkFailAsAide] }
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
            result: 'Result'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when finish_him on_success' do
    let(:action_block) { when_fail_as_aide_finish_him_on_success }
    let(:s1) { -> { false } }

    context 'when aide success' do
      let(:aide) { -> { true } }
      let(:railway_flow) { %i[step_one ForkFailAsAide] }
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
            result: 'Result'
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when aide failure' do
      let(:aide) { -> { false } }
      let(:railway_flow) { %i[step_one ForkFailAsAide fail_one] }
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
            result: 'Result'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when finish_him on_failure' do
    let(:action_block) { when_fail_as_aide_finish_him_on_failure }
    let(:s1) { -> { false } }

    context 'when aide success' do
      let(:aide) { -> { true } }
      let(:railway_flow) { %i[step_one ForkFailAsAide fail_one] }
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
            result: 'Result'
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when aide failure' do
      let(:aide) { -> { false } }
      let(:railway_flow) { %i[step_one ForkFailAsAide] }
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
            result: 'Result'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when if condition' do
    let(:action_block) { when_fail_as_aide_if_condition }
    let(:s1) { -> { false } }
    let(:aide) { -> { true } }

    context 'when condition success' do
      let(:condition) { true }
      let(:railway_flow) { %i[step_one ForkFailAsAide fail_one] }
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
            result: 'Result',
            condition: condition
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when condition failure' do
      let(:condition) { false }
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
            result: nil,
            condition: condition
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when unless condition' do
    let(:action_block) { when_fail_as_aide_unless_condition }
    let(:s1) { -> { false } }
    let(:aide) { -> { true } }

    context 'when condition success' do
      let(:condition) { false }
      let(:railway_flow) { %i[step_one ForkFailAsAide fail_one] }
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
            result: 'Result',
            condition: condition
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when condition failure' do
      let(:condition) { true }
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
            result: nil,
            condition: condition
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end
end
