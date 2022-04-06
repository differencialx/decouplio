# frozen_string_literal: true

RSpec.describe 'Decouplio::Action wrap cases' do
  include_context 'with basic spec setup'

  describe '#call' do
    let(:input_params) do
      {
        string_param: string_param,
        integer_param: integer_param
      }
    end
    let(:string_param) { '1' }
    let(:integer_param) { 2 }

    context 'when wrap with klass method' do
      context 'when success' do
        let(:action_block) { when_wrap_with_klass_method }

        before do
          allow(BeforeTransactionAction).to receive(:call)
          allow(AfterTransactionAction).to receive(:call)
          allow(ClassWithWrapperMethod).to receive(:transaction)
            .and_call_original
          allow(StubDummy).to receive(:call)
            .and_call_original
        end

        context 'when success' do
          let(:railway_flow) { %i[step_one wrap_name transaction_step_one transaction_step_two step_two] }

          it 'success' do
            expect(action).to be_success
            expect(action[:result]).to eq 7
            expect(action.railway_flow).to eq railway_flow
            expect(ClassWithWrapperMethod).to have_received(:transaction)
            expect(BeforeTransactionAction).to have_received(:call)
            expect(AfterTransactionAction).to have_received(:call)
            expect(StubDummy).to have_received(:call)
          end
        end

        context 'when failure' do
          let(:railway_flow) { %i[step_one wrap_name transaction_step_one transaction_step_two] }

          before do
            allow(StubDummy).to receive(:call)
              .and_return(false)
          end

          it 'fails' do
            expect(action).to be_failure
            expect(action[:result]).to eq 5
            expect(action.railway_flow).to eq railway_flow
            expect(action.errors).to be_empty
            expect(ClassWithWrapperMethod).to have_received(:transaction)
            expect(BeforeTransactionAction).to have_received(:call)
            expect(AfterTransactionAction).to have_received(:call)
            expect(StubDummy).to have_received(:call)
          end
        end
      end
    end

    context 'when simple wrap' do
      let(:action_block) { when_wrap_simple }

      before do
        allow(StubDummy).to receive(:call)
          .and_call_original
      end

      context 'when success' do
        let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two step_one step_two] }

        it 'success' do
          expect(action).to be_success
          expect(action.railway_flow).to eq railway_flow
          expect(action[:step_one]).to eq 'Success'
          expect(action[:step_two]).to eq 'Success'
          expect(action[:wrapper_step_one]).to eq 'Success'
          expect(StubDummy).to have_received(:call)
          expect(action[:fail_step]).to be_nil
        end
      end

      context 'when failure' do
        let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two fail_step] }

        before do
          allow(StubDummy).to receive(:call)
            .and_return(false)
        end

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq railway_flow
          expect(action[:step_one]).to be_nil
          expect(action[:step_two]).to be_nil
          expect(action[:wrapper_step_one]).to eq 'Success'
          expect(StubDummy).to have_received(:call)
          expect(action[:fail_step]).to eq 'Fail'
        end
      end
    end

    context 'when simple wrap with failure without failure track' do
      let(:action_block) { when_wrap_simple_with_failure_without_failure_track }

      context 'when success' do
        let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two step_one step_two] }

        before do
          allow(StubDummy).to receive(:call)
            .and_call_original
        end

        it 'success' do
          expect(action).to be_success
          expect(action.railway_flow).to eq railway_flow
          expect(action[:wrapper_step_one]).to eq 'Success'
          expect(action[:step_one]).to eq 'Success'
          expect(action[:step_two]).to eq 'Success'
          expect(StubDummy).to have_received(:call)
          expect(action.errors).to be_empty
        end
      end

      context 'when failure' do
        let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two handle_wrap_fail] }
        let(:expected_errors) do
          {
            inner_wrapper_fail: ['Inner wrapp error']
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_return(false)
        end

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq railway_flow
          expect(action[:wrapper_step_one]).to eq 'Success'
          expect(action[:step_one]).to be_nil
          expect(action[:step_two]).to be_nil
          expect(StubDummy).to have_received(:call)
          expect(action.errors).to eq expected_errors
        end
      end
    end

    context 'when simple wrap with failure with failure track' do
      let(:action_block) { when_wrap_simple_with_failure_with_failure_track }

      context 'when failure' do
        let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two handle_wrap_fail handle_fail] }
        let(:expected_errors) do
          {
            inner_wrapper_fail: ['Inner wrap error'],
            outer_fail: ['Outer failure error']
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_return(false)
        end

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq railway_flow
          expect(action[:wrapper_step_one]).to eq 'Success'
          expect(action[:step_one]).to be_nil
          expect(action[:step_two]).to be_nil
          expect(StubDummy).to have_received(:call)
          expect(action.errors).to eq expected_errors
        end
      end
    end

    context 'when simple wrap with on success' do
      let(:action_block) { when_wrap_on_success }
      let(:railway_flow) { %i[some_wrap wrapper_step_one wrapper_step_two step_two] }

      before do
        allow(StubDummy).to receive(:call)
          .and_call_original
      end

      it 'success' do
        expect(action).to be_success
        expect(action.railway_flow).to eq railway_flow
        expect(action[:wrapper_step_one]).to eq 'Success'
        expect(action[:step_one]).to be_nil
        expect(action[:step_two]).to eq 'Success'
        expect(StubDummy).to have_received(:call)
        expect(action.errors).to be_empty
      end
    end

    context 'when simple wrap with on failure' do
      let(:action_block) { when_wrap_on_failure }
      let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two handle_wrap_fail step_two] }
      let(:expected_errors) do
        {
          inner_wrapper_fail: ['Inner wrap error']
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_return(false)
      end

      it 'success' do # Tricky shit
        expect(action).to be_success
        expect(action.railway_flow).to eq railway_flow
        expect(action[:wrapper_step_one]).to eq 'Success'
        expect(action[:step_one]).to be_nil
        expect(action[:step_two]).to eq 'Success'
        expect(StubDummy).to have_received(:call)
        expect(action.errors).to eq expected_errors
      end
    end

    context 'when simple wrap inner on_success forward to outer wrap step' do
      let(:action_block) { when_wrap_inner_on_success_to_outer_step }
      let(:interpolation_values) do
        [
          Decouplio::OptionsValidator::YELLOW,
          '{:on_success=>:step_one}',
          'Step "step_one" is not defined',
          Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
          Decouplio::OptionsValidator::STEP_MANUAL_URL,
          Decouplio::OptionsValidator::NO_COLOR
        ]
      end
      let(:expected_message) do
        Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values
      end

      it 'raises an error' do
        expect { action }.to raise_error(
          Decouplio::Errors::OptionsValidationError,
          expected_message
        )
      end
    end

    context 'when simple wrap inner on_failure firward to outer wrap step' do
      let(:action_block) { when_wrap_inner_on_failure_to_outer_step }
      let(:interpolation_values) do
        [
          Decouplio::OptionsValidator::YELLOW,
          '{:on_failure=>:step_one}',
          'Step "step_one" is not defined',
          Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
          Decouplio::OptionsValidator::STEP_MANUAL_URL,
          Decouplio::OptionsValidator::NO_COLOR
        ]
      end
      let(:expected_message) do
        Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values
      end

      it 'raises an error' do
        expect { action }.to raise_error(
          Decouplio::Errors::OptionsValidationError,
          expected_message
        )
      end
    end

    context 'when simple wrap finish_him on_success' do
      let(:action_block) { when_wrap_finish_him_on_success }
      let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two] }

      before do
        allow(StubDummy).to receive(:call)
          .and_call_original
      end

      it 'success' do
        expect(action).to be_success
        expect(action.railway_flow).to eq railway_flow
        expect(action[:wrapper_step_one]).to eq 'Success'
        expect(action[:step_one]).to be_nil
        expect(action[:step_two]).to be_nil
        expect(action.errors).to be_empty
        expect(StubDummy).to have_received(:call)
      end
    end

    context 'when simple wrap finish_him on_failure' do
      let(:action_block) { when_wrap_finish_him_on_failure }
      let(:railway_flow) { %i[some_wrap wrapper_step_one wrapper_step_two handle_wrap_fail] }
      let(:expected_errors) do
        {
          inner_wrapper_fail: ['Inner wrap error']
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_return(false)
      end

      it 'fails' do
        expect(action).to be_failure
        expect(action.railway_flow).to eq railway_flow
        expect(action[:wrapper_step_one]).to eq 'Success'
        expect(action[:step_one]).to be_nil
        expect(action[:step_two]).to be_nil
        expect(action.errors).to eq expected_errors
        expect(StubDummy).to have_received(:call)
      end
    end

    context 'when simple wrap on_success finish_him' do
      let(:action_block) { when_wrap_on_success_finish_him }

      before do
        allow(StubDummy).to receive(:call)
          .and_call_original
      end

      context 'when success' do
        let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two] }

        it 'success' do
          expect(action).to be_success
          expect(action.railway_flow).to eq railway_flow
          expect(action[:wrapper_step_one]).to eq 'Success'
          expect(action[:step_one]).to be_nil
          expect(action[:step_two]).to be_nil
          expect(action.errors).to be_empty
          expect(StubDummy).to have_received(:call)
        end
      end
    end

    context 'when simple wrap on_failure finish_him' do
      let(:action_block) { when_wrap_on_failure_finish_him }

      context 'when failure' do
        before do
          allow(StubDummy).to receive(:call)
            .and_return(false)
        end

        let(:railway_flow) { %i[some_wrap wrapper_step_one wrapper_step_two handle_wrap_fail] }
        let(:expected_errors) do
          {
            inner_wrapper_fail: ['Inner wrap error']
          }
        end

        it 'fails' do
          expect(action).to be_failure
          expect(action.railway_flow).to eq railway_flow
          expect(action[:wrapper_step_one]).to eq 'Success'
          expect(action[:step_one]).to be_nil
          expect(action[:step_two]).to be_nil
          expect(action.errors).to eq expected_errors
          expect(StubDummy).to have_received(:call)
        end
      end
    end

    context 'when step on_success points to wrap' do
      let(:action_block) { when_step_on_success_points_to_wrap }

      before do
        allow(StubDummy).to receive(:call)
          .and_call_original
      end

      context 'when success' do
        let(:railway_flow) { %i[step_one some_wrap wrapper_step_one step_three] }

        it 'success' do
          expect(action).to be_success
          expect(action.railway_flow).to eq railway_flow
          expect(action[:step_one]).to be_nil
          expect(action[:step_two]).to be_nil
          expect(action[:wrapper_step_one]).to eq 'Success'
          expect(action[:step_three]).to eq 'Success'
          expect(action.errors).to be_empty
          expect(StubDummy).to have_received(:call)
        end
      end
    end

    context 'when step on_failure points to wrap' do
      let(:action_block) { when_step_on_failure_points_to_wrap }

      context 'when failure' do
        let(:railway_flow) { %i[step_one some_wrap wrapper_step_one step_three] }

        before do
          allow(StubDummy).to receive(:call)
            .and_return(false)
        end

        it 'success' do
          expect(action).to be_success
          expect(action.railway_flow).to eq railway_flow
          expect(action[:step_one]).to be_nil
          expect(action[:step_two]).to be_nil
          expect(action[:wrapper_step_one]).to eq 'Success'
          expect(action[:step_three]).to eq 'Success'
          expect(action.errors).to be_empty
          expect(StubDummy).to have_received(:call)
        end
      end
    end
  end
end
