# frozen_string_literal: true

RSpec.describe 'Decouplio::Action resq cases' do
  include_context 'with basic spec setup'

  describe '#call' do
    let(:input_params) do
      {
        strg_1: strg_1
      }
    end
    let(:strg_1) { nil }
    let(:error_message) { 'Some error message' }
    let(:error_class) { NoMethodError }
    let(:error_to_raise) { [error_class, error_message] }

    before do
      allow(StubDummy).to receive(:call)
        .and_raise(*error_to_raise)
    end

    context 'when handler method is not defined' do
      let(:action_block) { resq_undefined_handler_method }
      let(:interpolation_values) do
        [
          Decouplio::OptionsValidator::YELLOW,
          'Method "another_error_handler" is not defined',
          'Please define "another_error_handler" method',
          Decouplio::OptionsValidator::RESQ_ALLOWED_OPTIONS_MESSAGE,
          Decouplio::OptionsValidator::RESQ_MANUAL_URL,
          Decouplio::OptionsValidator::NO_COLOR
        ]
      end
      let(:expected_message) do
        Decouplio::OptionsValidator::RESQ_VALIDATION_ERROR_MESSAGE % interpolation_values
      end

      it 'raises an Decouplio::Errors::OptionsValidationError' do
        # binding.pry

        expect{ action }.to raise_error(
          Decouplio::Errors::OptionsValidationError,
          expected_message
        )
      end
    end

    context 'when there is no step' do
      let(:action_block) { resq_without_step }
      let(:expected_message) do
        <<~ERROR
          \033[1;33m
          "resq" should be defined only after:
          #{Decouplio::Step::MAIN_FLOW_TYPES.join("\n")}
          \033[0m
        ERROR
      end

      it 'raises Decouplio::Errors::OptionsValidationError' do
        expect{ action }.to raise_error(
          Decouplio::Errors::OptionsValidationError,
          expected_message
        )
      end
    end

    context 'when resq does not handle raised errors for next steps' do
      let(:action_block) { when_resq_does_not_handle_errors_for_next_steps }
      let(:error_class) { ArgumentError }

      before do
        allow(StubDummy).to receive(:call)
          .and_raise(*error_to_raise)
      end

      it 'raises an error' do
        expect { action }.to raise_error(
          ArgumentError,
          error_message
        )
      end
    end

    context 'when step' do
      context 'when single error class' do
        let(:action_block) { step_resq_single_error_class }
        let(:expected_errors) do
          {
            step_one_error: [error_message]
          }
        end
        let(:error_class) { StandardError }
        let(:railway_flow) { %i[step_one error_handler] }

        it 'handles the error' do
          expect(action).to be_failure
          expect(action.errors).to eq expected_errors
          expect(action.railway_flow).to eq railway_flow
        end

        context 'when error class is not handled' do
          let(:error_class) { NoMethodError }

          it 'handles the error' do
            expect{ action }.to raise_error(NoMethodError)
          end
        end
      end

      context 'when single error class success case' do
        let(:action_block) { step_resq_single_error_class_success }
        let(:error_class) { StandardError }
        let(:railway_flow) { %i[step_one error_handler] }

        it 'handles the error with out adding the error' do
          expect(action).to be_success
          expect(action[:result]).to eq error_message
          expect(action.railway_flow).to eq railway_flow
        end
      end

      context 'when several error classes' do
        let(:action_block) { step_resq_several_error_classes }
        let(:expected_errors) do
          {
            step_one_error: [error_message]
          }
        end
        let(:railway_flow) { %i[step_one error_handler] }

        context 'when StandardError' do
          let(:error_class) { StandardError }
          let(:error_message) { 'StandardError error message' }

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end

        context 'when ArgumentError' do
          let(:error_class) { ArgumentError }
          let(:error_message) { 'ArgumentError error message' }

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end
      end

      context 'when several handler methods' do
        let(:action_block) { step_resq_several_handler_methods }

        context 'when StandardError' do
          let(:error_class) { StandardError }
          let(:error_message) { 'StandardError error message' }
          let(:expected_errors) do
            {
              step_one_error: [error_message]
            }
          end
          let(:railway_flow) { %i[step_one error_handler] }

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end

        context 'when ArgumentError' do
          let(:error_class) { ArgumentError }
          let(:error_message) { 'ArgumentError error message' }
          let(:expected_errors) do
            {
              step_one_error: [error_message]
            }
          end
          let(:railway_flow) { %i[step_one error_handler] }

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end

        context 'when NoMethodError' do
          let(:error_class) { NoMethodError }
          let(:error_message) { 'NoMethodError error message' }
          let(:expected_errors) do
            {
              another_error: [error_message]
            }
          end
          let(:railway_flow) { %i[step_one another_error_handler] }

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end
      end
    end

    context 'when fail' do
      context 'when single error class' do
        let(:action_block) { fail_resq_single_error_class }
        let(:error_class) { StandardError }
        let(:error_message) { 'StandardError error message' }
        let(:expected_errors) do
          {
            fail_step: [error_message]
          }
        end
        let(:railway_flow) { %i[step_one fail_step error_handler] }

        it 'handles the error' do
          expect(action).to be_failure
          expect(action.errors).to eq expected_errors
          expect(action.railway_flow).to eq railway_flow
        end
      end

      context 'when several error classes' do
        let(:action_block) { fail_resq_several_error_classes }
        let(:railway_flow) { %i[step_one fail_step error_handler] }

        context 'when StandardError' do
          let(:error_class) { StandardError }
          let(:error_message) { 'StandardError error message' }
          let(:expected_errors) do
            {
              fail_step: [error_message]
            }
          end

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end

        context 'when ArgumentError' do
          let(:error_class) { ArgumentError }
          let(:error_message) { 'ArgumentError error message' }
          let(:expected_errors) do
            {
              fail_step: [error_message]
            }
          end

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end
      end

      context 'when several handler methods' do
        let(:action_block) { fail_resq_several_handler_methods }

        context 'when StandardError' do
          let(:error_class) { StandardError }
          let(:error_message) { 'StandardError error message' }
          let(:expected_errors) do
            {
              fail_step: [error_message]
            }
          end
          let(:railway_flow) { %i[step_one fail_step error_handler] }

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end

        context 'when ArgumentError' do
          let(:error_class) { ArgumentError }
          let(:error_message) { 'ArgumentError error message' }
          let(:expected_errors) do
            {
              fail_step: [error_message]
            }
          end
          let(:railway_flow) { %i[step_one fail_step error_handler] }

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end

        context 'when NoMethodError' do
          let(:error_class) { NoMethodError }
          let(:error_message) { 'NoMethodError error message' }
          let(:expected_errors) do
            {
              another_error: [error_message]
            }
          end
          let(:railway_flow) { %i[step_one fail_step another_error_handler] }

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end
      end
    end

    context 'when pass' do
      context 'when single error class' do
        let(:action_block) { pass_resq_single_error_class }
        let(:error_class) { StandardError }
        let(:error_message) { 'StandardError error message' }
        let(:expected_errors) do
          {
            step_one_error: [error_message]
          }
        end
        let(:railway_flow) { %i[step_one error_handler] }

        it 'handles the error' do
          expect(action).to be_failure
          expect(action.errors).to eq expected_errors
          expect(action.railway_flow).to eq railway_flow
        end
      end

      context 'when several error classes' do
        let(:action_block) { pass_resq_several_error_classes }
        let(:railway_flow) { %i[step_one error_handler] }

        context 'when StandardError' do
          let(:error_class) { StandardError }
          let(:error_message) { 'StandardError error message' }
          let(:expected_errors) do
            {
              step_one_error: [error_message]
            }
          end

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end

        context 'when ArgumentError' do
          let(:error_class) { ArgumentError }
          let(:error_message) { 'ArgumentError error message' }
          let(:expected_errors) do
            {
              step_one_error: [error_message]
            }
          end

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end
      end

      context 'when several handler methods' do
        let(:action_block) { pass_resq_several_handler_methods }

        context 'when StandardError' do
          let(:error_class) { StandardError }
          let(:error_message) { 'StandardError error message' }
          let(:expected_errors) do
            {
              step_one_error: [error_message]
            }
          end
          let(:railway_flow) { %i[step_one error_handler] }

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end

        context 'when ArgumentError' do
          let(:error_class) { ArgumentError }
          let(:error_message) { 'ArgumentError error message' }
          let(:expected_errors) do
            {
              step_one_error: [error_message]
            }
          end
          let(:railway_flow) { %i[step_one error_handler] }

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end

        context 'NoMethodError' do
          let(:error_class) { NoMethodError }
          let(:error_message) { 'NoMethodError error message' }
          let(:expected_errors) do
            {
              another_error: [error_message]
            }
          end
          let(:railway_flow) { %i[step_one another_error_handler] }

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end
      end
    end

    context 'when strategy' do
      context 'when single error class' do
        let(:action_block) { strategy_resq_single_error_class }
        let(:error_class) { StandardError }
        let(:error_message) { 'StandardError error message' }
        let(:expected_errors) do
          {
            step_one_error: [error_message]
          }
        end

        context 'when strg_1 => stp1' do
          let(:strg_1) { :stp1 }
          let(:railway_flow) { %i[step_one error_handler] }

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end

        context 'when strg_1 => stp2' do
          let(:strg_1) { :stp2 }
          let(:railway_flow) { %i[step_two error_handler] }

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end
      end

      context 'when several error classes' do
        let(:action_block) { strategy_resq_several_error_classes }
        let(:expected_errors) do
          {
            step_one_error: [error_message]
          }
        end

        context 'when StandardError' do
          let(:error_class) { StandardError }
          let(:error_message) { 'StandardError error message' }

          context 'when strg_1 => stp1' do
            let(:strg_1) { :stp1 }
            let(:railway_flow) { %i[step_one error_handler] }

            it 'handles the error' do
              expect(action).to be_failure
              expect(action.errors).to eq expected_errors
              expect(action.railway_flow).to eq railway_flow
            end
          end

          context 'when strg_1 => stp2' do
            let(:strg_1) { :stp2 }
            let(:railway_flow) { %i[step_two error_handler] }

            it 'handles the error' do
              expect(action).to be_failure
              expect(action.errors).to eq expected_errors
              expect(action.railway_flow).to eq railway_flow
            end
          end
        end

        context 'when ArgumentError' do
          let(:error_class) { ArgumentError }
          let(:error_message) { 'ArgumentError error message' }

          context 'when strg_1 => stp1' do
            let(:strg_1) { :stp1 }
            let(:railway_flow) { %i[step_one error_handler] }

            it 'handles the error' do
              expect(action).to be_failure
              expect(action.errors).to eq expected_errors
              expect(action.railway_flow).to eq railway_flow
            end
          end

          context 'when strg_1 => stp2' do
            let(:strg_1) { :stp2 }
            let(:railway_flow) { %i[step_two error_handler] }

            it 'handles the error' do
              expect(action).to be_failure
              expect(action.errors).to eq expected_errors
              expect(action.railway_flow).to eq railway_flow
            end
          end
        end
      end

      context 'when squad inner resq' do
        let(:action_block) { strategy_resq_inner_squad_resq }
        let(:error_class) { ArgumentError }
        let(:error_message) { 'ArgumentError error message' }

        context 'when strg_1 => stp1' do
          let(:strg_1) { :stp1 }
          let(:railway_flow) { %i[step_two inner_rescue] }
          let(:expected_errors) do
            {
              inner_rescue: [error_message]
            }
          end

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end

        context 'when strg_1 => stp2' do
          let(:strg_1) { :stp2 }
          let(:railway_flow) { %i[step_two error_handler] }
          let(:expected_errors) do
            {
              step_one_error: [error_message]
            }
          end

          it 'handles the error' do
            expect(action).to be_failure
            expect(action.errors).to eq expected_errors
            expect(action.railway_flow).to eq railway_flow
          end
        end
      end
    end

    context 'when wrap' do
      context 'when wrap with klass method' do
        let(:input_params) do
          {
            string_param: string_param,
            integer_param: integer_param
          }
        end
        let(:string_param) { '1' }
        let(:integer_param) { 2 }
        let(:action_block) { when_wrap_with_klass_method }
        let(:error_class) { ClassWithWrapperMethodError }
        let(:expected_errors) do
          {
            wrapper_error: [error_message]
          }
        end

        before do
          allow(BeforeTransactionAction).to receive(:call)
          allow(AfterTransactionAction).to receive(:call)
          allow(ClassWithWrapperMethod).to receive(:transaction)
            .and_call_original
          allow(StubDummy).to receive(:call)
            .and_raise(*error_to_raise)
        end

        it 'fails' do
          expect(action).to be_failure
          expect(action[:result]).to eq 5
          expect(action.errors).to eq expected_errors
          expect(ClassWithWrapperMethod).to have_received(:transaction)
          expect(BeforeTransactionAction).to have_received(:call)
          expect(AfterTransactionAction).not_to have_received(:call)
          expect(StubDummy).to have_received(:call)
        end
      end

      context 'when simple wrap' do
        let(:action_block) { when_wrap_simple }

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
            expect(action[:wrapper_step_two]).to be_nil
            expect(action[:step_one]).to eq 'Success'
            expect(action[:step_two]).to eq 'Success'
            expect(action[:fail_step]).to be_nil
            expect(action.errors).to be_empty
            expect(StubDummy).to have_received(:call)
          end
        end

        context 'when failure' do
          let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two handler_step fail_step] }
          let(:error_class) { ArgumentError }
          let(:expected_errors) do
            {
              wrapper_error: [error_message]
            }
          end

          before do
            allow(StubDummy).to receive(:call)
              .and_raise(*error_to_raise)
          end

          it 'failure' do
            expect(action).to be_failure
            expect(action.railway_flow).to eq railway_flow
            expect(action[:wrapper_step_one]).to eq 'Success'
            expect(action[:wrapper_step_two]).to be_nil
            expect(action[:step_one]).to be_nil
            expect(action[:step_two]).to be_nil
            expect(action[:fail_step]).to eq 'Fail'
            expect(action.errors).to eq expected_errors
          end
        end
      end
    end
  end
end
