# frozen_string_literal: true

RSpec.describe 'Decouplio::Action wrap cases' do
  include_context 'with basic spec setup'

  describe '#call' do
    let(:input_params) do
      {
        string_param: string_param,
        integer_param: integer_param,
        param1: param1,
        param2: param2,
        param3: param3,
        param4: param4,
        param5: param5,
        param6: param6,
        octo_key: octo_key
      }
    end
    let(:string_param) { '1' }
    let(:integer_param) { 2 }
    let(:param1) { nil }
    let(:param2) { nil }
    let(:param3) { nil }
    let(:param4) { nil }
    let(:param5) { nil }
    let(:param6) { nil }
    let(:octo_key) { nil }

    context 'when wrap without resq with klass method' do
      context 'when success' do
        let(:action_block) { wrap_without_resq_with_klass_method }

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
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: {},
              state: {
                result: 7
              }
            }
          end

          it_behaves_like 'check action state'

          it 'calls proper methods' do
            action
            expect(ClassWithWrapperMethod).to have_received(:transaction)
            expect(BeforeTransactionAction).to have_received(:call)
            expect(AfterTransactionAction).to have_received(:call)
            expect(StubDummy).to have_received(:call)
          end
        end

        context 'when failure' do
          let(:railway_flow) { %i[step_one wrap_name transaction_step_one transaction_step_two] }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                result: 5
              }
            }
          end

          before do
            allow(StubDummy).to receive(:call)
            .and_return(false)
          end

          it_behaves_like 'check action state'

          it 'calls proper methods' do
            action
            expect(ClassWithWrapperMethod).to have_received(:transaction)
            expect(BeforeTransactionAction).to have_received(:call)
            expect(AfterTransactionAction).to have_received(:call)
            expect(StubDummy).to have_received(:call)
          end
        end
      end
    end

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
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: {},
              state: {
                result: 7
              }
            }
          end

          it_behaves_like 'check action state'

          it 'calls proper methods' do
            action
            expect(ClassWithWrapperMethod).to have_received(:transaction)
            expect(BeforeTransactionAction).to have_received(:call)
            expect(AfterTransactionAction).to have_received(:call)
            expect(StubDummy).to have_received(:call)
          end
        end

        context 'when failure' do
          let(:railway_flow) { %i[step_one wrap_name transaction_step_one transaction_step_two] }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                result: 5
              }
            }
          end

          before do
            allow(StubDummy).to receive(:call)
              .and_return(false)
          end

          it_behaves_like 'check action state'

          it 'calls proper methods' do
            action
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
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: 'Success',
              wrapper_step_one: 'Success',
              fail_step: nil
            }
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when failure' do
        let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two fail_step] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: nil,
              step_two: nil,
              wrapper_step_one: 'Success',
              fail_step: 'Fail'
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_return(false)
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end
    end

    context 'when simple wrap with failure without failure track' do
      let(:action_block) { when_wrap_simple_with_failure_without_failure_track }

      context 'when success' do
        let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two step_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: 'Success',
              wrapper_step_one: 'Success'
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_call_original
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when failure' do
        let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two handle_wrap_fail] }
        let(:expected_errors) do
          {
            inner_wrapper_fail: ['Inner wrapp error']
          }
        end
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              step_one: nil,
              step_two: nil,
              wrapper_step_one: 'Success'
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_return(false)
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
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
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              step_one: nil,
              step_two: nil,
              wrapper_step_one: 'Success'
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_return(false)
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end
    end

    context 'when simple wrap with on success' do
      let(:action_block) { when_wrap_on_success }
      let(:railway_flow) { %i[some_wrap wrapper_step_one wrapper_step_two step_two] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: nil,
            step_two: 'Success',
            wrapper_step_one: 'Success'
          }
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_call_original
      end

      it_behaves_like 'check action state'
      it_behaves_like 'stub dummy was called'
    end

    context 'when simple wrap with on failure' do
      let(:action_block) { when_wrap_on_failure }
      let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two handle_wrap_fail step_two] }
      let(:expected_errors) do
        {
          inner_wrapper_fail: ['Inner wrap error']
        }
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: expected_errors,
          state: {
            step_one: nil,
            step_two: 'Success',
            wrapper_step_one: 'Success'
          }
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_return(false)
      end

      it_behaves_like 'check action state'
      it_behaves_like 'stub dummy was called'
    end

    context 'when simple wrap inner on_success forward to outer wrap step' do
      let(:action_block) { when_wrap_inner_on_success_to_outer_step }
      let(:interpolation_values) do
        [
          Decouplio::Const::Colors::YELLOW,
          '{:on_success=>:step_one}',
          'Step "step_one" is not defined',
          Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Step::MANUAL_URL,
          Decouplio::Const::Colors::NO_COLOR
        ]
      end
      let(:expected_message) do
        Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values
      end

      it 'raises an error' do
        expect { action }.to raise_error(
          Decouplio::Errors::StepIsNotDefinedError,
          expected_message
        )
      end
    end

    context 'when simple wrap inner on_failure firward to outer wrap step' do
      let(:action_block) { when_wrap_inner_on_failure_to_outer_step }
      let(:interpolation_values) do
        [
          Decouplio::Const::Colors::YELLOW,
          '{:on_failure=>:step_one}',
          'Step "step_one" is not defined',
          Decouplio::Const::Validations::Step::ALLOWED_OPTIONS_MESSAGE,
          Decouplio::Const::Validations::Step::MANUAL_URL,
          Decouplio::Const::Colors::NO_COLOR
        ]
      end
      let(:expected_message) do
        Decouplio::Const::Validations::Step::VALIDATION_ERROR_MESSAGE % interpolation_values
      end

      it 'raises an error' do
        expect { action }.to raise_error(
          Decouplio::Errors::StepIsNotDefinedError,
          expected_message
        )
      end
    end

    context 'when simple wrap finish_him on_success' do
      let(:action_block) { when_wrap_finish_him_on_success }
      let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: nil,
            step_two: nil,
            wrapper_step_one: 'Success'
          }
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_call_original
      end

      it_behaves_like 'check action state'
      it_behaves_like 'stub dummy was called'
    end

    context 'when simple wrap finish_him on_failure' do
      let(:action_block) { when_wrap_finish_him_on_failure }
      let(:railway_flow) { %i[some_wrap wrapper_step_one wrapper_step_two handle_wrap_fail] }
      let(:expected_errors) do
        {
          inner_wrapper_fail: ['Inner wrap error']
        }
      end
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: expected_errors,
          state: {
            step_one: nil,
            step_two: nil,
            wrapper_step_one: 'Success'
          }
        }
      end

      before do
        allow(StubDummy).to receive(:call)
          .and_return(false)
      end

      it_behaves_like 'check action state'
      it_behaves_like 'stub dummy was called'
    end

    context 'when simple wrap on_success finish_him' do
      let(:action_block) { when_wrap_on_success_finish_him }

      before do
        allow(StubDummy).to receive(:call)
          .and_call_original
      end

      context 'when success' do
        let(:railway_flow) { %i[wrap_name wrapper_step_one wrapper_step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: nil,
              step_two: nil,
              wrapper_step_one: 'Success'
            }
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
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
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: expected_errors,
            state: {
              step_one: nil,
              step_two: nil,
              wrapper_step_one: 'Success'
            }
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
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
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: nil,
              step_two: nil,
              step_three: 'Success',
              wrapper_step_one: 'Success'
            }
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end
    end

    context 'when step on_failure points to wrap' do
      let(:action_block) { when_step_on_failure_points_to_wrap }

      context 'when failure' do
        let(:railway_flow) { %i[step_one some_wrap wrapper_step_one step_three] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: nil,
              step_two: nil,
              step_three: 'Success',
              wrapper_step_one: 'Success'
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_return(false)
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end
    end

    context 'when fail before wrap' do
      let(:action_block) { when_fail_before_wrap }

      context 'when step_one passes' do
        let(:param1) { -> { true } }

        context 'when wrapper_step_one passes' do
          let(:railway_flow) { %i[step_one some_wrap wrapper_step_one step_three] }
          let(:param2) { -> { true } }

          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: true,
                step_three: 'Success',
                wrapper_step_one: true,
                fail_one: nil,
                fail_two: nil,
                fail_three: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when wrapper_step_one fails' do
          let(:railway_flow) { %i[step_one some_wrap wrapper_step_one fail_two fail_three] }
          let(:param2) { -> { false } }

          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: true,
                step_three: nil,
                wrapper_step_one: false,
                fail_one: nil,
                fail_two: 'Failure',
                fail_three: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when step_one fails' do
        let(:railway_flow) { %i[step_one fail_one fail_two fail_three] }
        let(:param1) { -> { false } }

        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: false,
              step_three: nil,
              wrapper_step_one: nil,
              fail_one: 'Failure',
              fail_two: 'Failure',
              fail_three: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when fail on_success points to wrap on_failure points to fail track' do
      let(:action_block) { when_fail_on_success_points_to_wrap_on_failure_to_fail_track }

      context 'when step_one success' do
        context 'when step_two success' do
          context 'when some_wrap success' do
            context 'when step_three success' do
              let(:railway_flow) { %i[step_one step_two some_wrap wrapper_step_one step_three] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { true } }
              let(:param5) { -> { true } }

              let(:expected_state) do
                {
                  action_status: :success,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    step_two: true,
                    step_three: true,
                    wrapper_step_one: true,
                    fail_one: nil,
                    fail_two: nil,
                    fail_three: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when step_three failure' do
              let(:railway_flow) { %i[step_one step_two some_wrap wrapper_step_one step_three fail_three] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { false } }
              let(:param4) { -> { true } }
              let(:param5) { -> { true } }

              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    step_two: true,
                    step_three: false,
                    wrapper_step_one: true,
                    fail_one: nil,
                    fail_two: nil,
                    fail_three: 'Failure'
                  }
                }
              end

              it_behaves_like 'check action state'
            end
          end

          context 'when some_wrap failure' do
            context 'when step_three success' do
              let(:railway_flow) { %i[step_one step_two some_wrap wrapper_step_one step_three] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { false } }
              let(:param5) { -> { true } }

              let(:expected_state) do
                {
                  action_status: :success,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    step_two: true,
                    step_three: true,
                    wrapper_step_one: false,
                    fail_one: nil,
                    fail_two: nil,
                    fail_three: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when step_three failure' do
              let(:railway_flow) { %i[step_one step_two some_wrap wrapper_step_one step_three fail_three] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { false } }
              let(:param4) { -> { false } }
              let(:param5) { -> { true } }

              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    step_two: true,
                    step_three: false,
                    wrapper_step_one: false,
                    fail_one: nil,
                    fail_two: nil,
                    fail_three: 'Failure'
                  }
                }
              end

              it_behaves_like 'check action state'
            end
          end
        end

        context 'when step_two failure' do
          let(:railway_flow) { %i[step_one step_two fail_two fail_three] }
          let(:param1) { -> { true } }
          let(:param2) { -> { false } }
          let(:param3) { -> { true } }
          let(:param4) { -> { true } }

          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: true,
                step_two: false,
                step_three: nil,
                wrapper_step_one: nil,
                fail_one: nil,
                fail_two: 'Failure',
                fail_three: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when step_one failure' do
        context 'when fail_one success' do
          context 'when some_wrap success' do
            context 'when step_three success' do
              let(:railway_flow) { %i[step_one fail_one some_wrap wrapper_step_one step_three] }
              let(:param1) { -> { false } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { true } }
              let(:param5) { -> { true } }

              let(:expected_state) do
                {
                  action_status: :success,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: false,
                    step_two: nil,
                    step_three: true,
                    wrapper_step_one: true,
                    fail_one: true,
                    fail_two: nil,
                    fail_three: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when step_three failure' do
              let(:railway_flow) { %i[step_one fail_one some_wrap wrapper_step_one step_three fail_three] }
              let(:param1) { -> { false } }
              let(:param2) { -> { true } }
              let(:param3) { -> { false } }
              let(:param4) { -> { true } }
              let(:param5) { -> { true } }

              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: false,
                    step_two: nil,
                    step_three: false,
                    wrapper_step_one: true,
                    fail_one: true,
                    fail_two: nil,
                    fail_three: 'Failure'
                  }
                }
              end

              it_behaves_like 'check action state'
            end
          end

          context 'when some_wrap failure' do
            context 'when step_three success' do
              let(:railway_flow) { %i[step_one fail_one some_wrap wrapper_step_one step_three] }
              let(:param1) { -> { false } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { false } }
              let(:param5) { -> { true } }

              let(:expected_state) do
                {
                  action_status: :success,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: false,
                    step_two: nil,
                    step_three: true,
                    wrapper_step_one: false,
                    fail_one: true,
                    fail_two: nil,
                    fail_three: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when step_three failure' do
              let(:railway_flow) { %i[step_one fail_one some_wrap wrapper_step_one step_three fail_three] }
              let(:param1) { -> { false } }
              let(:param2) { -> { true } }
              let(:param3) { -> { false } }
              let(:param4) { -> { false } }
              let(:param5) { -> { true } }

              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: false,
                    step_two: nil,
                    step_three: false,
                    wrapper_step_one: false,
                    fail_one: true,
                    fail_two: nil,
                    fail_three: 'Failure'
                  }
                }
              end

              it_behaves_like 'check action state'
            end
          end
        end

        context 'when fail_one failure' do
          let(:railway_flow) { %i[step_one fail_one fail_two fail_three] }
          let(:param1) { -> { false } }
          let(:param2) { -> { true } }
          let(:param3) { -> { true } }
          let(:param4) { -> { true } }
          let(:param5) { -> { false } }

          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: false,
                step_two: nil,
                step_three: nil,
                wrapper_step_one: nil,
                fail_one: false,
                fail_two: 'Failure',
                fail_three: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end
    end

    context 'when fail on_failure points to wrap on_success to success_track' do
      let(:action_block) { when_fail_on_failure_points_to_wrap_on_success_to_success_track }

      context 'when step_one success' do
        context 'when step_two success' do
          context 'when some_wrap success' do
            let(:railway_flow) { %i[step_one step_two some_wrap wrapper_step_one fail_three] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }

            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  step_two: true,
                  step_three: nil,
                  wrapper_step_one: true,
                  fail_one: nil,
                  fail_two: nil,
                  fail_three: 'Failure'
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when some_wrap failure' do
            let(:railway_flow) { %i[step_one step_two some_wrap wrapper_step_one fail_two fail_three] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }
            let(:param4) { -> { false } }

            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  step_two: true,
                  step_three: nil,
                  wrapper_step_one: false,
                  fail_one: nil,
                  fail_two: 'Failure',
                  fail_three: 'Failure'
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end

        context 'when step_two failure' do
          let(:railway_flow) { %i[step_one step_two fail_two fail_three] }
          let(:param1) { -> { true } }
          let(:param2) { -> { true } }
          let(:param3) { -> { false } }
          let(:param4) { -> { true } }

          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: true,
                step_two: false,
                step_three: nil,
                wrapper_step_one: nil,
                fail_one: nil,
                fail_two: 'Failure',
                fail_three: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when step_one failure' do
        context 'when fail_one success' do
          let(:railway_flow) { %i[step_one fail_one fail_two fail_three] }
          let(:param1) { -> { false } }
          let(:param2) { -> { true } }
          let(:param3) { -> { true } }
          let(:param4) { -> { true } }

          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: false,
                step_two: nil,
                step_three: nil,
                wrapper_step_one: nil,
                fail_one: true,
                fail_two: 'Failure',
                fail_three: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when fail_one failure' do
          context 'when some_wrap success' do
            let(:railway_flow) { %i[step_one fail_one some_wrap wrapper_step_one fail_three] }
            let(:param1) { -> { false } }
            let(:param2) { -> { false } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }

            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: false,
                  step_two: nil,
                  step_three: nil,
                  wrapper_step_one: true,
                  fail_one: false,
                  fail_two: nil,
                  fail_three: 'Failure'
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when some_wrap failure' do
            let(:railway_flow) { %i[step_one fail_one some_wrap wrapper_step_one fail_two fail_three] }
            let(:param1) { -> { false } }
            let(:param2) { -> { false } }
            let(:param3) { -> { true } }
            let(:param4) { -> { false } }

            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: false,
                  step_two: nil,
                  step_three: nil,
                  wrapper_step_one: false,
                  fail_one: false,
                  fail_two: 'Failure',
                  fail_three: 'Failure'
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end
      end
    end

    context 'when pass before wrap' do
      let(:action_block) { when_pass_before_wrap }

      context 'when pass_one success' do
        context 'when some_wrap success' do
          context 'when step_three success' do
            let(:railway_flow) { %i[pass_one some_wrap wrapper_step_one step_three] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }

            let(:expected_state) do
              {
                action_status: :success,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: true,
                  step_three: true,
                  wrapper_step_one: true,
                  fail_one: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when step_three failure' do
            let(:railway_flow) { %i[pass_one some_wrap wrapper_step_one step_three] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { false } }

            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: true,
                  step_three: false,
                  wrapper_step_one: true,
                  fail_one: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end

        context 'when some_wrap failure' do
          let(:railway_flow) { %i[pass_one some_wrap wrapper_step_one] }
          let(:param1) { -> { true } }
          let(:param2) { -> { false } }
          let(:param3) { -> { true } }

          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                pass_one: true,
                step_three: nil,
                wrapper_step_one: false,
                fail_one: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when pass_one failure' do
        context 'when some_wrap success' do
          context 'when step_three success' do
            let(:railway_flow) { %i[pass_one some_wrap wrapper_step_one step_three] }
            let(:param1) { -> { false } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }

            let(:expected_state) do
              {
                action_status: :success,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: false,
                  step_three: true,
                  wrapper_step_one: true,
                  fail_one: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when step_three failure' do
            let(:railway_flow) { %i[pass_one some_wrap wrapper_step_one step_three] }
            let(:param1) { -> { false } }
            let(:param2) { -> { true } }
            let(:param3) { -> { false } }

            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: false,
                  step_three: false,
                  wrapper_step_one: true,
                  fail_one: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end

        context 'when some_wrap failure' do
          let(:railway_flow) { %i[pass_one some_wrap wrapper_step_one] }
          let(:param1) { -> { false } }
          let(:param2) { -> { false } }
          let(:param3) { -> { true } }

          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                pass_one: false,
                step_three: nil,
                wrapper_step_one: false,
                fail_one: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end
    end

    context 'when octo before wrap' do
      let(:action_block) { when_octo_before_wrap }

      context 'when step_one success' do
        context 'when octo_ctx_key octo_key1' do
          let(:octo_key) { :octo_key1 }

          context 'when step_palp1 success' do
            context 'when some_wrap success' do
              let(:railway_flow) { %i[step_one octo_name step_palp1 some_wrap wrapper_step_one fail_two] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { true } }
              let(:param5) { -> { true } }
              let(:param6) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    step_palp1: true,
                    step_palp2: nil,
                    step_two: nil,
                    wrapper_step_one: true,
                    step_three: nil,
                    fail_two: 'Failure'
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when some_wrap failure' do
              context 'when step_three success' do
                let(:railway_flow) { %i[step_one octo_name step_palp1 some_wrap wrapper_step_one step_three] }
                let(:param1) { -> {true } }
                let(:param2) { -> {true } }
                let(:param3) { -> {true } }
                let(:param4) { -> {true } }
                let(:param5) { -> {false } }
                let(:param6) { -> {true } }
                let(:expected_state) do
                  {
                    action_status: :success,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      step_one: true,
                      fail_one: nil,
                      step_palp1: true,
                      step_palp2: nil,
                      step_two: nil,
                      wrapper_step_one: false,
                      step_three: true,
                      fail_two: nil
                    }
                  }
                end

                it_behaves_like 'check action state'
              end

              context 'when step_three failure' do
                let(:railway_flow) { %i[step_one octo_name step_palp1 some_wrap wrapper_step_one step_three fail_two] }
                let(:param1) { -> { true } }
                let(:param2) { -> { true } }
                let(:param3) { -> { true } }
                let(:param4) { -> { true } }
                let(:param5) { -> { false } }
                let(:param6) { -> { false } }
                let(:expected_state) do
                  {
                    action_status: :failure,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      step_one: true,
                      fail_one: nil,
                      step_palp1: true,
                      step_palp2: nil,
                      step_two: nil,
                      wrapper_step_one: false,
                      step_three: false,
                      fail_two: 'Failure'
                    }
                  }
                end

                it_behaves_like 'check action state'
              end
            end
          end

          context 'when step_palp1 failure' do
            context 'when step_three success' do
              let(:railway_flow) { %i[step_one octo_name step_palp1 step_three] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { false } }
              let(:param4) { -> { true } }
              let(:param5) { -> { true } }
              let(:param6) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :success,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    step_palp1: false,
                    step_palp2: nil,
                    step_two: nil,
                    wrapper_step_one: nil,
                    step_three: true,
                    fail_two: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when step_three failure' do
              let(:railway_flow) { %i[step_one octo_name step_palp1 step_three fail_two] }
              let(:param1) { -> { true }  }
              let(:param2) { -> { true }  }
              let(:param3) { -> { false }  }
              let(:param4) { -> { true }  }
              let(:param5) { -> { true }  }
              let(:param6) { -> { false }  }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    step_palp1: false,
                    step_palp2: nil,
                    step_two: nil,
                    wrapper_step_one: nil,
                    step_three: false,
                    fail_two: 'Failure'
                  }
                }
              end

              it_behaves_like 'check action state'
            end
          end
        end

        context 'when octo_ctx_key octo_key2' do
          let(:octo_key) { :octo_key2 }

          context 'when step_palp2 success' do
            let(:railway_flow) { %i[step_one octo_name step_palp2 fail_two] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:param5) { -> { true } }
            let(:param6) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  fail_one: nil,
                  step_palp1: nil,
                  step_palp2: true,
                  step_two: nil,
                  wrapper_step_one: nil,
                  step_three: nil,
                  fail_two: 'Failure'
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when step_palp2 failure' do
            context 'when some_wrap success' do
              let(:railway_flow) { %i[step_one octo_name step_palp2 some_wrap wrapper_step_one fail_two] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { false } }
              let(:param5) { -> { true } }
              let(:param6) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    step_palp1: nil,
                    step_palp2: false,
                    step_two: nil,
                    wrapper_step_one: true,
                    step_three: nil,
                    fail_two: 'Failure'
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when some_wrap failure' do
              context 'when step_three success' do
                let(:railway_flow) { %i[step_one octo_name step_palp2 some_wrap wrapper_step_one step_three] }
                let(:param1) { -> { true } }
                let(:param2) { -> { true } }
                let(:param3) { -> { true } }
                let(:param4) { -> { false } }
                let(:param5) { -> { false } }
                let(:param6) { -> { true } }
                let(:expected_state) do
                  {
                    action_status: :success,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      step_one: true,
                      fail_one: nil,
                      step_palp1: nil,
                      step_palp2: false,
                      step_two: nil,
                      wrapper_step_one: false,
                      step_three: true,
                      fail_two: nil
                    }
                  }
                end

                it_behaves_like 'check action state'
              end

              context 'when step_three failure' do
                let(:railway_flow) { %i[step_one octo_name step_palp2 some_wrap wrapper_step_one step_three fail_two] }
                let(:param1) { -> { true } }
                let(:param2) { -> { true } }
                let(:param3) { -> { true } }
                let(:param4) { -> { false } }
                let(:param5) { -> { false } }
                let(:param6) { -> { false } }
                let(:expected_state) do
                  {
                    action_status: :failure,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      step_one: true,
                      fail_one: nil,
                      step_palp1: nil,
                      step_palp2: false,
                      step_two: nil,
                      wrapper_step_one: false,
                      step_three: false,
                      fail_two: 'Failure'
                    }
                  }
                end

                it_behaves_like 'check action state'
              end
            end
          end
        end
      end

      context 'when step_one failure' do
        context 'when fail_one success' do
          let(:railway_flow) { %i[step_one fail_one fail_two] }
          let(:param1) { -> { false } }
          let(:param2) { -> { true } }
          let(:param3) { -> { true } }
          let(:param4) { -> { true } }
          let(:param5) { -> { true } }
          let(:param6) { -> { true } }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: false,
                fail_one: true,
                step_palp1: nil,
                step_palp2: nil,
                step_two: nil,
                wrapper_step_one: nil,
                step_three: nil,
                fail_two: 'Failure'
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when fail_one failure' do
          context 'when octo_ctx_key octo_key1' do
            let(:octo_key) { :octo_key1 }

            context 'when step_palp1 success' do
              context 'when some_wrap success' do
                let(:railway_flow) { %i[step_one fail_one octo_name step_palp1 some_wrap wrapper_step_one fail_two] }
                let(:param1) { -> { false } }
                let(:param2) { -> { false } }
                let(:param3) { -> { true } }
                let(:param4) { -> { true } }
                let(:param5) { -> { true } }
                let(:param6) { -> { true } }
                let(:expected_state) do
                  {
                    action_status: :failure,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      step_one: false,
                      fail_one: false,
                      step_palp1: true,
                      step_palp2: nil,
                      step_two: nil,
                      wrapper_step_one: true,
                      step_three: nil,
                      fail_two: 'Failure'
                    }
                  }
                end

                it_behaves_like 'check action state'
              end

              context 'when some_wrap failure' do
                context 'when step_three success' do
                  let(:railway_flow) { %i[step_one fail_one octo_name step_palp1 some_wrap wrapper_step_one step_three] }
                  let(:param1) { -> { false } }
                  let(:param2) { -> { false } }
                  let(:param3) { -> { true } }
                  let(:param4) { -> { true } }
                  let(:param5) { -> { false } }
                  let(:param6) { -> { true } }
                  let(:expected_state) do
                    {
                      action_status: :success,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        step_one: false,
                        fail_one: false,
                        step_palp1: true,
                        step_palp2: nil,
                        step_two: nil,
                        wrapper_step_one: false,
                        step_three: true,
                        fail_two: nil
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end

                context 'when step_three failure' do
                  let(:railway_flow) { %i[step_one fail_one octo_name step_palp1 some_wrap wrapper_step_one step_three fail_two] }
                  let(:param1) { -> { false } }
                  let(:param2) { -> { false } }
                  let(:param3) { -> { true } }
                  let(:param4) { -> { true } }
                  let(:param5) { -> { false } }
                  let(:param6) { -> { false } }
                  let(:expected_state) do
                    {
                      action_status: :failure,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        step_one: false,
                        fail_one: false,
                        step_palp1: true,
                        step_palp2: nil,
                        step_two: nil,
                        wrapper_step_one: false,
                        step_three: false,
                        fail_two: 'Failure'
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end
              end
            end

            context 'when step_palp1 failure' do
              context 'when step_three success' do
                let(:railway_flow) { %i[step_one fail_one octo_name step_palp1 step_three] }
                let(:param1) { -> { false } }
                let(:param2) { -> { false } }
                let(:param3) { -> { false } }
                let(:param4) { -> { true } }
                let(:param5) { -> { true } }
                let(:param6) { -> { true } }
                let(:expected_state) do
                  {
                    action_status: :success,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      step_one: false,
                      fail_one: false,
                      step_palp1: false,
                      step_palp2: nil,
                      step_two: nil,
                      wrapper_step_one: nil,
                      step_three: true,
                      fail_two: nil
                    }
                  }
                end

                it_behaves_like 'check action state'
              end

              context 'when step_three failure' do
                let(:railway_flow) { %i[step_one fail_one octo_name step_palp1 step_three fail_two] }
                let(:param1) { -> { false } }
                let(:param2) { -> { false } }
                let(:param3) { -> { false } }
                let(:param4) { -> { true } }
                let(:param5) { -> { true } }
                let(:param6) { -> { false } }
                let(:expected_state) do
                  {
                    action_status: :failure,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      step_one: false,
                      fail_one: false,
                      step_palp1: false,
                      step_palp2: nil,
                      step_two: nil,
                      wrapper_step_one: nil,
                      step_three: false,
                      fail_two: 'Failure'
                    }
                  }
                end

                it_behaves_like 'check action state'
              end
            end
          end

          context 'when octo_ctx_key octo_key2' do
            let(:octo_key) { :octo_key2 }

            context 'when step_palp2 success' do
              let(:railway_flow) { %i[step_one fail_one octo_name step_palp2 fail_two] }
              let(:param1) { -> { false } }
              let(:param2) { -> { false } }
              let(:param3) { -> { true } }
              let(:param4) { -> { true } }
              let(:param5) { -> { true } }
              let(:param6) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: false,
                    fail_one: false,
                    step_palp1: nil,
                    step_palp2: true,
                    step_two: nil,
                    wrapper_step_one: nil,
                    step_three: nil,
                    fail_two: 'Failure'
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when step_palp2 failure' do
              context 'when some_wrap success' do
                let(:railway_flow) { %i[step_one fail_one octo_name step_palp2 some_wrap wrapper_step_one fail_two] }
                let(:param1) { -> { false } }
                let(:param2) { -> { false } }
                let(:param3) { -> { true } }
                let(:param4) { -> { false } }
                let(:param5) { -> { true } }
                let(:param6) { -> { true } }
                let(:expected_state) do
                  {
                    action_status: :failure,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      step_one: false,
                      fail_one: false,
                      step_palp1: nil,
                      step_palp2: false,
                      step_two: nil,
                      wrapper_step_one: true,
                      step_three: nil,
                      fail_two: 'Failure'
                    }
                  }
                end

                it_behaves_like 'check action state'
              end

              context 'when some_wrap failure' do
                context 'when step_three success' do
                  let(:railway_flow) { %i[step_one fail_one octo_name step_palp2 some_wrap wrapper_step_one step_three] }
                  let(:param1) { -> { false } }
                  let(:param2) { -> { false } }
                  let(:param3) { -> { true } }
                  let(:param4) { -> { false } }
                  let(:param5) { -> { false } }
                  let(:param6) { -> { true } }
                  let(:expected_state) do
                    {
                      action_status: :success,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        step_one: false,
                        fail_one: false,
                        step_palp1: nil,
                        step_palp2: false,
                        step_two: nil,
                        wrapper_step_one: false,
                        step_three: true,
                        fail_two: nil
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end

                context 'when step_three failure' do
                  let(:railway_flow) { %i[step_one fail_one octo_name step_palp2 some_wrap wrapper_step_one step_three fail_two] }
                  let(:param1) { -> { false } }
                  let(:param2) { -> { false } }
                  let(:param3) { -> { true } }
                  let(:param4) { -> { false } }
                  let(:param5) { -> { false } }
                  let(:param6) { -> { false } }
                  let(:expected_state) do
                    {
                      action_status: :failure,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        step_one: false,
                        fail_one: false,
                        step_palp1: nil,
                        step_palp2: false,
                        step_two: nil,
                        wrapper_step_one: false,
                        step_three: false,
                        fail_two: 'Failure'
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end
              end
            end
          end
        end
      end
    end

    context 'when step resq before wrap' do
      let(:action_block) { when_step_resq_before_wrap }
      let(:step_error_message) { 'Step error message' }
      let(:fail_error_message) { 'Fail error message' }
      let(:pass_error_message) { 'Pass error message' }

      context 'when step_one success' do
        context 'when wrap_name success' do
          context 'when step_two success' do
            context 'when pass_one success' do
              context 'when step_three success' do
                let(:railway_flow) { %i[step_one wrap_name wrap_step_one step_two pass_one step_three] }
                let(:param1) { -> { true } }
                let(:param2) { -> { true } }
                let(:param3) { -> { true } }
                let(:param4) { -> { true } }
                let(:param5) { -> { true } }
                let(:param6) { -> { true } }
                let(:expected_state) do
                  {
                    action_status: :success,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      step_one: true,
                      error_handler_step: nil,
                      wrap_step_one: true,
                      fail_one: nil,
                      error_handler_fail: nil,
                      step_two: true,
                      pass_one: true,
                      error_handler_pass: nil,
                      step_three: true
                    }
                  }
                end

                it_behaves_like 'check action state'
              end

              context 'when step_three failure' do
                let(:railway_flow) { %i[step_one wrap_name wrap_step_one step_two pass_one step_three] }
                let(:param1) { -> { true } }
                let(:param2) { -> { true } }
                let(:param3) { -> { true } }
                let(:param4) { -> { true } }
                let(:param5) { -> { true } }
                let(:param6) { -> { false } }
                let(:expected_state) do
                  {
                    action_status: :failure,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      step_one: true,
                      error_handler_step: nil,
                      wrap_step_one: true,
                      fail_one: nil,
                      error_handler_fail: nil,
                      step_two: true,
                      pass_one: true,
                      error_handler_pass: nil,
                      step_three: false
                    }
                  }
                end

                it_behaves_like 'check action state'
              end
            end

            context 'when pass_one failure' do
              context 'when step_three success' do
                let(:railway_flow) { %i[step_one wrap_name wrap_step_one step_two pass_one step_three] }
                let(:param1) { -> { true } }
                let(:param2) { -> { true } }
                let(:param3) { -> { true } }
                let(:param4) { -> { true } }
                let(:param5) { -> { false } }
                let(:param6) { -> { true } }
                let(:expected_state) do
                  {
                    action_status: :success,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      step_one: true,
                      error_handler_step: nil,
                      wrap_step_one: true,
                      fail_one: nil,
                      error_handler_fail: nil,
                      step_two: true,
                      pass_one: false,
                      error_handler_pass: nil,
                      step_three: true
                    }
                  }
                end

                it_behaves_like 'check action state'
              end

              context 'when step_three failure' do
                let(:railway_flow) { %i[step_one wrap_name wrap_step_one step_two pass_one step_three] }
                let(:param1) { -> { true } }
                let(:param2) { -> { true } }
                let(:param3) { -> { true } }
                let(:param4) { -> { true } }
                let(:param5) { -> { false } }
                let(:param6) { -> { false } }
                let(:expected_state) do
                  {
                    action_status: :failure,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      step_one: true,
                      error_handler_step: nil,
                      wrap_step_one: true,
                      fail_one: nil,
                      error_handler_fail: nil,
                      step_two: true,
                      pass_one: false,
                      error_handler_pass: nil,
                      step_three: false
                    }
                  }
                end

                it_behaves_like 'check action state'
              end
            end

            context 'when pass_one raises an error' do
              let(:railway_flow) { %i[step_one wrap_name wrap_step_one step_two pass_one error_handler_pass] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { true } }
              let(:param5) { -> { raise ArgumentError, pass_error_message } }
              let(:param6) { -> { false } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    error_handler_step: nil,
                    wrap_step_one: true,
                    fail_one: nil,
                    error_handler_fail: nil,
                    step_two: true,
                    pass_one: nil,
                    error_handler_pass: pass_error_message,
                    step_three: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end
          end

          context 'when step_two failure' do
            let(:railway_flow) { %i[step_one wrap_name wrap_step_one step_two] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }
            let(:param4) { -> { false } }
            let(:param5) { -> { true } }
            let(:param6) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  error_handler_step: nil,
                  wrap_step_one: true,
                  fail_one: nil,
                  error_handler_fail: nil,
                  step_two: false,
                  pass_one: nil,
                  error_handler_pass: nil,
                  step_three: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end

        context 'when wrap_name failure' do
          context 'when fail_one success' do
            let(:railway_flow) { %i[step_one wrap_name wrap_step_one fail_one] }
            let(:param1) { -> { true } }
            let(:param2) { -> { false } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:param5) { -> { true } }
            let(:param6) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  error_handler_step: nil,
                  wrap_step_one: false,
                  fail_one: true,
                  error_handler_fail: nil,
                  step_two: nil,
                  pass_one: nil,
                  error_handler_pass: nil,
                  step_three: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when fail_one failure' do
            let(:railway_flow) { %i[step_one wrap_name wrap_step_one fail_one] }
            let(:param1) { -> { true } }
            let(:param2) { -> { false } }
            let(:param3) { -> { false } }
            let(:param4) { -> { true } }
            let(:param5) { -> { true } }
            let(:param6) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  error_handler_step: nil,
                  wrap_step_one: false,
                  fail_one: false,
                  error_handler_fail: nil,
                  step_two: nil,
                  pass_one: nil,
                  error_handler_pass: nil,
                  step_three: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when fail_one raises an error' do
            let(:railway_flow) { %i[step_one wrap_name wrap_step_one fail_one error_handler_fail] }
            let(:param1) { -> { true } }
            let(:param2) { -> { false } }
            let(:param3) { -> { raise ArgumentError, fail_error_message } }
            let(:param4) { -> { true } }
            let(:param5) { -> { true } }
            let(:param6) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  error_handler_step: nil,
                  wrap_step_one: false,
                  fail_one: nil,
                  error_handler_fail: fail_error_message,
                  step_two: nil,
                  pass_one: nil,
                  error_handler_pass: nil,
                  step_three: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end
      end

      context 'when step_one failure' do
        context 'when fail_one success' do
          let(:railway_flow) { %i[step_one fail_one] }
          let(:param1) { -> { false } }
          let(:param2) { -> { true } }
          let(:param3) { -> { true } }
          let(:param4) { -> { true } }
          let(:param5) { -> { true } }
          let(:param6) { -> { true } }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: false,
                error_handler_step: nil,
                wrap_step_one: nil,
                fail_one: true,
                error_handler_fail: nil,
                step_two: nil,
                pass_one: nil,
                error_handler_pass: nil,
                step_three: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when fail_one failure' do
          let(:railway_flow) { %i[step_one fail_one] }
          let(:param1) { -> { false } }
          let(:param2) { -> { true } }
          let(:param3) { -> { false } }
          let(:param4) { -> { true } }
          let(:param5) { -> { true } }
          let(:param6) { -> { true } }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: false,
                error_handler_step: nil,
                wrap_step_one: nil,
                fail_one: false,
                error_handler_fail: nil,
                step_two: nil,
                pass_one: nil,
                error_handler_pass: nil,
                step_three: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when fail_one raises an error' do
          let(:railway_flow) { %i[step_one fail_one error_handler_fail] }
          let(:param1) { -> { false } }
          let(:param2) { -> { true } }
          let(:param3) { -> { raise ArgumentError, fail_error_message } }
          let(:param4) { -> { true } }
          let(:param5) { -> { true } }
          let(:param6) { -> { true } }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: false,
                error_handler_step: nil,
                wrap_step_one: nil,
                fail_one: nil,
                error_handler_fail: fail_error_message,
                step_two: nil,
                pass_one: nil,
                error_handler_pass: nil,
                step_three: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when step_one raises an error' do
        context 'when fail_one success' do
          let(:railway_flow) { %i[step_one error_handler_step fail_one] }
          let(:param1) { -> { raise ArgumentError, step_error_message } }
          let(:param2) { -> { true } }
          let(:param3) { -> { true } }
          let(:param4) { -> { true } }
          let(:param5) { -> { true } }
          let(:param6) { -> { true } }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: nil,
                error_handler_step: step_error_message,
                wrap_step_one: nil,
                fail_one: true,
                error_handler_fail: nil,
                step_two: nil,
                pass_one: nil,
                error_handler_pass: nil,
                step_three: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when fail_one failure' do
          let(:railway_flow) { %i[step_one error_handler_step fail_one] }
          let(:param1) { -> { raise ArgumentError, step_error_message } }
          let(:param2) { -> { true } }
          let(:param3) { -> { false } }
          let(:param4) { -> { true } }
          let(:param5) { -> { true } }
          let(:param6) { -> { true } }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: nil,
                error_handler_step: step_error_message,
                wrap_step_one: nil,
                fail_one: false,
                error_handler_fail: nil,
                step_two: nil,
                pass_one: nil,
                error_handler_pass: nil,
                step_three: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when fail_one raises an error' do
          let(:railway_flow) { %i[step_one error_handler_step fail_one error_handler_fail] }
          let(:param1) { -> { raise ArgumentError, step_error_message } }
          let(:param2) { -> { true } }
          let(:param3) { -> { raise ArgumentError, fail_error_message } }
          let(:param4) { -> { true } }
          let(:param5) { -> { true } }
          let(:param6) { -> { true } }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: nil,
                error_handler_step: step_error_message,
                wrap_step_one: nil,
                fail_one: nil,
                error_handler_fail: fail_error_message,
                step_two: nil,
                pass_one: nil,
                error_handler_pass: nil,
                step_three: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end
    end

    context 'when fail resq before wrap' do
      let(:action_block) { when_fail_resq_before_wrap }
      let(:fail_error_message) { 'Fail error message' }

      context 'when step_one success' do
        context 'when wrap_name success' do
          context 'when step_two success' do
            let(:railway_flow) { %i[step_one wrap_name wrap_step_one step_two] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:param5) { -> { true } }
            let(:expected_state) do
              {
                action_status: :success,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  fail_one: nil,
                  error_handler_fail: nil,
                  wrap_step_one: true,
                  step_two: true,
                  fail_two: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when step_two failure' do
            context 'when fail_two success' do
              let(:railway_flow) { %i[step_one wrap_name wrap_step_one step_two fail_two] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { false } }
              let(:param5) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    error_handler_fail: nil,
                    wrap_step_one: true,
                    step_two: false,
                    fail_two: true
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when fail_two failure' do
              let(:railway_flow) { %i[step_one wrap_name wrap_step_one step_two fail_two] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { false } }
              let(:param5) { -> { false } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    error_handler_fail: nil,
                    wrap_step_one: true,
                    step_two: false,
                    fail_two: false
                  }
                }
              end

              it_behaves_like 'check action state'
            end
          end
        end

        context 'when wrap_name failure' do
          context 'when fail_two success' do
            let(:railway_flow) { %i[step_one wrap_name wrap_step_one fail_two] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { false } }
            let(:param4) { -> { true } }
            let(:param5) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  fail_one: nil,
                  error_handler_fail: nil,
                  wrap_step_one: false,
                  step_two: nil,
                  fail_two: true
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when fail_two failure' do
            let(:railway_flow) { %i[step_one wrap_name wrap_step_one fail_two] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { false } }
            let(:param4) { -> { true } }
            let(:param5) { -> { false } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  fail_one: nil,
                  error_handler_fail: nil,
                  wrap_step_one: false,
                  step_two: nil,
                  fail_two: false
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end
      end

      context 'when step_one failure' do
        context 'when fail_one success' do
          context 'when fail_two success' do
            let(:railway_flow) { %i[step_one fail_one fail_two] }
            let(:param1) { -> { false } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:param5) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: false,
                  fail_one: true,
                  error_handler_fail: nil,
                  wrap_step_one: nil,
                  step_two: nil,
                  fail_two: true
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when fail_two failure' do
            let(:railway_flow) { %i[step_one fail_one fail_two] }
            let(:param1) { -> { false } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:param5) { -> { false } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: false,
                  fail_one: true,
                  error_handler_fail: nil,
                  wrap_step_one: nil,
                  step_two: nil,
                  fail_two: false
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end

        context 'when fail_one failure' do
          context 'when fail_two success' do
            let(:railway_flow) { %i[step_one fail_one fail_two] }
            let(:param1) { -> { false } }
            let(:param2) { -> { false } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:param5) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: false,
                  fail_one: false,
                  error_handler_fail: nil,
                  wrap_step_one: nil,
                  step_two: nil,
                  fail_two: true
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when fail_two failure' do
            let(:railway_flow) { %i[step_one fail_one fail_two] }
            let(:param1) { -> { false } }
            let(:param2) { -> { false } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:param5) { -> { false } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: false,
                  fail_one: false,
                  error_handler_fail: nil,
                  wrap_step_one: nil,
                  step_two: nil,
                  fail_two: false
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end

        context 'when fail_one raises an error' do
          context 'when fail_two success' do
            let(:railway_flow) { %i[step_one fail_one error_handler_fail fail_two] }
            let(:param1) { -> { false } }
            let(:param2) { -> { raise ArgumentError, fail_error_message } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:param5) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: false,
                  fail_one: nil,
                  error_handler_fail: fail_error_message,
                  wrap_step_one: nil,
                  step_two: nil,
                  fail_two: true
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when fail_two failure' do
            let(:railway_flow) { %i[step_one fail_one error_handler_fail fail_two] }
            let(:param1) { -> { false } }
            let(:param2) { -> { raise ArgumentError, fail_error_message } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:param5) { -> { false } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: false,
                  fail_one: nil,
                  error_handler_fail: fail_error_message,
                  wrap_step_one: nil,
                  step_two: nil,
                  fail_two: false
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end
      end
    end

    context 'when pass resq before wrap' do
      let(:action_block) { when_pass_resq_before_wrap }
      let(:fail_error_message) { 'Fail error message' }
      let(:wrap_error_message) { 'Wrap error message' }

      context 'when pass_one success' do
        context 'when wrap_one success' do
          context 'when step_one success' do
            let(:railway_flow) { %i[pass_one wrap_one wrap_step_one step_one] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:expected_state) do
              {
                action_status: :success,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: true,
                  error_handler_pass: nil,
                  wrap_step_one: true,
                  error_handler_wrap: nil,
                  fail_one: nil,
                  step_one: true
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when step_one failure' do
            let(:railway_flow) { %i[pass_one wrap_one wrap_step_one step_one] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }
            let(:param4) { -> { false } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: true,
                  error_handler_pass: nil,
                  wrap_step_one: true,
                  error_handler_wrap: nil,
                  fail_one: nil,
                  step_one: false
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end

        context 'when wrap_one failure' do
          context 'when fail_one success' do
            let(:railway_flow) { %i[pass_one wrap_one wrap_step_one fail_one] }
            let(:param1) { -> { true } }
            let(:param2) { -> { false } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: true,
                  error_handler_pass: nil,
                  wrap_step_one: false,
                  error_handler_wrap: nil,
                  fail_one: true,
                  step_one: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when fail_one failure' do
            let(:railway_flow) { %i[pass_one wrap_one wrap_step_one fail_one] }
            let(:param1) { -> { true } }
            let(:param2) { -> { false } }
            let(:param3) { -> { false } }
            let(:param4) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: true,
                  error_handler_pass: nil,
                  wrap_step_one: false,
                  error_handler_wrap: nil,
                  fail_one: false,
                  step_one: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end

        context 'when wrap_one raises an error' do
          context 'when fail_one success' do
            let(:railway_flow) { %i[pass_one wrap_one wrap_step_one error_handler_wrap fail_one] }
            let(:param1) { -> { true } }
            let(:param2) { -> { raise ArgumentError, wrap_error_message } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: true,
                  error_handler_pass: nil,
                  wrap_step_one: nil,
                  error_handler_wrap: wrap_error_message,
                  fail_one: true,
                  step_one: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when fail_one failure' do
            let(:railway_flow) { %i[pass_one wrap_one wrap_step_one error_handler_wrap fail_one] }
            let(:param1) { -> { true } }
            let(:param2) { -> { raise ArgumentError, wrap_error_message } }
            let(:param3) { -> { false } }
            let(:param4) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: true,
                  error_handler_pass: nil,
                  wrap_step_one: nil,
                  error_handler_wrap: wrap_error_message,
                  fail_one: false,
                  step_one: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end
      end

      context 'when pass_one failure' do
        context 'when wrap_one success' do
          context 'when step_one success' do
            let(:railway_flow) { %i[pass_one wrap_one wrap_step_one step_one] }
            let(:param1) { -> { false } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:expected_state) do
              {
                action_status: :success,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: false,
                  error_handler_pass: nil,
                  wrap_step_one: true,
                  error_handler_wrap: nil,
                  fail_one: nil,
                  step_one: true
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when step_one failure' do
            let(:railway_flow) { %i[pass_one wrap_one wrap_step_one step_one] }
            let(:param1) { -> { false } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }
            let(:param4) { -> { false } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: false,
                  error_handler_pass: nil,
                  wrap_step_one: true,
                  error_handler_wrap: nil,
                  fail_one: nil,
                  step_one: false
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end

        context 'when wrap_one failure' do
          context 'when fail_one success' do
            let(:railway_flow) { %i[pass_one wrap_one wrap_step_one fail_one] }
            let(:param1) { -> { false } }
            let(:param2) { -> { false } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: false,
                  error_handler_pass: nil,
                  wrap_step_one: false,
                  error_handler_wrap: nil,
                  fail_one: true,
                  step_one: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when fail_one failure' do
            let(:railway_flow) { %i[pass_one wrap_one wrap_step_one fail_one] }
            let(:param1) { -> { false } }
            let(:param2) { -> { false } }
            let(:param3) { -> { false } }
            let(:param4) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: false,
                  error_handler_pass: nil,
                  wrap_step_one: false,
                  error_handler_wrap: nil,
                  fail_one: false,
                  step_one: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end

        context 'when wrap_one raises an error' do
          context 'when fail_one success' do
            let(:railway_flow) { %i[pass_one wrap_one wrap_step_one error_handler_wrap fail_one] }
            let(:param1) { -> { false } }
            let(:param2) { -> { raise ArgumentError, wrap_error_message } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: false,
                  error_handler_pass: nil,
                  wrap_step_one: nil,
                  error_handler_wrap: wrap_error_message,
                  fail_one: true,
                  step_one: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when fail_one failure' do
            let(:railway_flow) { %i[pass_one wrap_one wrap_step_one error_handler_wrap fail_one] }
            let(:param1) { -> { false } }
            let(:param2) { -> { raise ArgumentError, wrap_error_message } }
            let(:param3) { -> { false } }
            let(:param4) { -> { true } }
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  pass_one: false,
                  error_handler_pass: nil,
                  wrap_step_one: nil,
                  error_handler_wrap: wrap_error_message,
                  fail_one: false,
                  step_one: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end
      end

      context 'when pass_one raises an error' do
        context 'when fail_one success' do
          let(:railway_flow) { %i[pass_one error_handler_pass fail_one] }
          let(:param1) { -> { raise ArgumentError, wrap_error_message } }
          let(:param2) { -> { true } }
          let(:param3) { -> { true } }
          let(:param4) { -> { true } }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                pass_one: nil,
                error_handler_pass: wrap_error_message,
                wrap_step_one: nil,
                error_handler_wrap: nil,
                fail_one: true,
                step_one: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when fail_one failure' do
          let(:railway_flow) { %i[pass_one error_handler_pass fail_one] }
          let(:param1) { -> { raise ArgumentError, wrap_error_message } }
          let(:param2) { -> { true } }
          let(:param3) { -> { false } }
          let(:param4) { -> { true } }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                pass_one: nil,
                error_handler_pass: wrap_error_message,
                wrap_step_one: nil,
                error_handler_wrap: nil,
                fail_one: false,
                step_one: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end
    end
  end
end
