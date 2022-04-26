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
      let(:action_block) { inner_action }
      let(:param1) { 'pass' }
      let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step] }

      it 'pass' do
        expect(action).to be_success
        expect(action[:inner_action_param]).to eq param1
        expect(action.railway_flow).to eq railway_flow
        expect(action[:result]).to be true
        expect(action.errors).to be_empty
      end
    end

    context 'when inner action fails' do
      let(:action_block) { inner_action }
      let(:param1) { 'fail' }
      let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step handle_fail handle_fail] }
      let(:expected_errors) do
        {
          inner_step_failed: ['Something went wrong inner'],
          outer_step_failed: ['Something went wrong outer']
        }
      end

      it 'fails' do
        expect(action).to be_failure
        expect(action[:inner_action_param]).to eq param1
        expect(action.railway_flow).to eq railway_flow
        expect(action[:result]).to be false
        expect(action.errors).to eq expected_errors
      end
    end

    context 'when on_success' do
      let(:action_block) { inner_action_on_success }

      context 'when inner action success' do
        let(:param1) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step handle_fail] }
        let(:expected_errors) do
          {
            outer_step_failed: ['Something went wrong outer']
          }
        end

        it 'fails' do
          expect(action).to be_failure
          expect(action[:inner_action_param]).to eq param1
          expect(action.railway_flow).to eq railway_flow
          expect(action[:result]).to be true
          expect(action.errors).to eq expected_errors
        end
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

        it 'fails' do
          expect(action).to be_failure
          expect(action[:inner_action_param]).to eq param1
          expect(action.railway_flow).to eq railway_flow
          expect(action[:result]).to be false
          expect(action.errors).to eq expected_errors
        end
      end
    end

    context 'when on failure' do
      let(:action_block) { inner_action_on_failure }

      context 'when inner action success' do
        let(:param1) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step step_one] }
        let(:expected_errors) do
          {

          }
        end

        it 'pass' do
          expect(action).to be_success
          expect(action[:inner_action_param]).to eq param1
          expect(action.railway_flow).to eq railway_flow
          expect(action[:result]).to be true
          expect(action.errors).to be_empty
          expect(action[:step_one]).to eq 'step_one'
        end
      end

      context 'when inner action fails' do
        let(:param1) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step handle_fail step_one] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end

        it 'success' do
          expect(action).to be_success
          expect(action[:inner_action_param]).to eq param1
          expect(action.railway_flow).to eq railway_flow
          expect(action[:result]).to be false
          expect(action.errors).to eq expected_errors
          expect(action[:step_one]).to eq 'step_one'
        end
      end
    end

    context 'when inner action finish him on_success' do
      let(:action_block) { inner_action_finish_him_on_success }

      context 'when inner action success' do
        let(:param1) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step] }
        let(:expected_errors) do
          {

          }
        end

        it 'pass' do
          expect(action).to be_success
          expect(action[:inner_action_param]).to eq param1
          expect(action.railway_flow).to eq railway_flow
          expect(action[:result]).to be true
          expect(action.errors).to be_empty
          expect(action[:step_one]).to be_nil
        end
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

        it 'fails' do
          expect(action).to be_failure
          expect(action[:inner_action_param]).to eq param1
          expect(action.railway_flow).to eq railway_flow
          expect(action[:result]).to be false
          expect(action.errors).to eq expected_errors
          expect(action[:step_one]).to be_nil
        end
      end
    end

    context 'when inner action finish him on_failure' do
      let(:action_block) { inner_action_finish_him_on_failure }

      context 'when inner action success' do
        let(:param1) { 'pass' }
        let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step step_one] }

        it 'pass' do
          expect(action).to be_success
          expect(action[:inner_action_param]).to eq param1
          expect(action.railway_flow).to eq railway_flow
          expect(action[:result]).to be true
          expect(action.errors).to be_empty
          expect(action[:step_one]).to eq 'step_one'
        end
      end

      context 'when inner action fails' do
        let(:param1) { 'fail' }
        let(:railway_flow) { %i[assign_inner_action_param process_inner_action inner_step handle_fail] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end

        it 'fails' do
          expect(action).to be_failure
          expect(action[:inner_action_param]).to eq param1
          expect(action.railway_flow).to eq railway_flow
          expect(action[:result]).to be false
          expect(action.errors).to eq expected_errors
          expect(action[:step_one]).to be_nil
        end
      end
    end

    context 'when inner action as fail step' do
      let(:action_block) { when_inner_action_as_fail_step }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step fail_two] }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be true
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq param2
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to eq 'Failure'
          expect(action.errors).to be_empty
        end
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step handle_fail fail_two] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be false
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq param2
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to eq 'Failure'
          expect(action.errors).to eq expected_errors
        end
      end
    end

    context 'when inner action as fail step on_success' do
      let(:action_block) { when_inner_action_as_fail_step_on_success }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step step_two] }

        it 'success' do
          expect(action).to be_success
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be true
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq param2
          expect(action[:step_two]).to eq 'Success'
          expect(action[:fail_two]).to be_nil
          expect(action.errors).to be_empty
        end
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step handle_fail fail_two] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be false
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq param2
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to eq  'Failure'
          expect(action.errors).to eq expected_errors
        end
      end
    end

    context 'when inner action as fail on_failure' do
      let(:action_block) { when_inner_action_as_fail_step_on_failure }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step fail_two] }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be true
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq param2
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to eq 'Failure'
          expect(action.errors).to be_empty
        end
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step handle_fail step_two] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end

        it 'fails' do
          expect(action).to be_success
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be false
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq param2
          expect(action[:step_two]).to eq 'Success'
          expect(action[:fail_two]).to be_nil
          expect(action.errors).to eq expected_errors
        end
      end
    end

    context 'when inner action as fail step on_success finish_him' do
      let(:action_block) { when_inner_action_as_fail_step_on_success_finish_him }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step] }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be true
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq param2
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to be_nil
          expect(action.errors).to be_empty
        end
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step handle_fail fail_two] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be false
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq param2
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to eq 'Failure'
          expect(action.errors).to eq expected_errors
        end
      end
    end

    context 'when inner action as fail step on_failure finish_him' do
      let(:action_block) { when_inner_action_as_fail_step_on_failure_finish_him }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step fail_two] }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be true
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq param2
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to eq 'Failure'
          expect(action.errors).to be_empty
        end
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step handle_fail] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be false
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq param2
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to be_nil
          expect(action.errors).to eq expected_errors
        end
      end
    end

    context 'when inner action as fail step finish_him on_success' do
      let(:action_block) { when_inner_action_as_fail_step_finish_him_on_success }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step] }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be true
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq param2
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to be_nil
          expect(action.errors).to be_empty
        end
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step handle_fail fail_two] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be false
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq param2
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to eq 'Failure'
          expect(action.errors).to eq expected_errors
        end
      end
    end

    context 'when inner action as fail step finish_hiim on_failure' do
      let(:action_block) { when_inner_action_as_fail_step_finish_him_on_failure }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step fail_two] }

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be true
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq param2
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to eq 'Failure'
          expect(action.errors).to be_empty
        end
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one fail_one inner_step handle_fail] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be false
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq param2
          expect(action[:step_two]).to be_nil
          expect(action[:fail_two]).to be_nil
          expect(action.errors).to eq expected_errors
        end
      end
    end

    context 'when inner action as pass step' do
      let(:action_block) { when_inner_action_as_pass }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one pass_one inner_step step_two] }

        it 'success' do
          expect(action).to be_success
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be true
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq 'Success'
          expect(action[:step_two]).to eq 'Success'
          expect(action.errors).to be_empty
        end
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one pass_one inner_step handle_fail step_two] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end

        it 'success' do
          expect(action).to be_success
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be false
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq 'Success'
          expect(action[:step_two]).to eq 'Success'
          expect(action.errors).to eq expected_errors
        end
      end
    end

    context 'when inner action as pass step with finish_him' do
      let(:action_block) { when_inner_action_as_pass_finish_him }
      let(:param1) { inner_action_param }
      let(:param2) { false }

      context 'when inner action success' do
        let(:inner_action_param) { 'pass' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one pass_one inner_step] }

        it 'success' do
          expect(action).to be_success
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be true
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq 'Success'
          expect(action[:step_two]).to be_nil
          expect(action.errors).to be_empty
        end
      end

      context 'when inner action failure' do
        let(:inner_action_param) { 'fail' }
        let(:expected_railway_flow) { %i[assign_inner_action_param step_one pass_one inner_step handle_fail] }
        let(:expected_errors) do
          {
            inner_step_failed: ['Something went wrong inner']
          }
        end

        it 'success' do
          expect(action).to be_success
          expect(action.railway_flow).to eq expected_railway_flow
          expect(action[:result]).to be false
          expect(action[:inner_action_param]).to eq param1
          expect(action[:step_one]).to eq 'Success'
          expect(action[:step_two]).to be_nil
          expect(action.errors).to eq expected_errors
        end
      end
    end
  end
end
