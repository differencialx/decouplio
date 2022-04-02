# frozen_string_literal: true

RSpec.describe 'Decouplio::Action resq cases' do
  include_context 'with basic spec setup'

  xdescribe '#call' do
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
      let(:expected_message) do
        ''
      end

      it 'raises an Decouplio::Errors::OptionsValidationError' do
        expect{ action }.to raise_error(
          Decouplio::Errors::OptionsValidationError,
          expected_message
        )
      end
    end

    context 'when there is no step' do
      let(:action_block) { resq_without_step }
      let(:expected_message) do
        ''
      end

      it 'raises Decouplio::Errors::OptionsValidationError' do
        expect{ action }.to raise_error(
          Decouplio::Errors::OptionsValidationError,
          expected_message
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
        let(:error_class) { ArgumentError }
        let(:error_message) { 'ArgumentError error message' }

        context 'when strg_1 => stp1' do
          let(:strg_1) { :stp1 }
          let(:railway_flow) { %i[step_two inner_rescue] }
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

        context 'when strg_1 => stp2' do
          let(:strg_1) { :stp2 }
          let(:railway_flow) { %i[step_two error_handler] }
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
      end
    end
  end
end
