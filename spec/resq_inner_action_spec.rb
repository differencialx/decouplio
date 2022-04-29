# frozen_string_literal: true

RSpec.describe 'Resq with inner action cases' do
  include_context 'with basic spec setup'

  describe '#call' do
    let(:input_params) do
      {
        param1: param1,
        param2: param2
      }
    end
    let(:param1) { nil }
    let(:param2) { nil }

    before do
      allow(StubDummy).to receive(:call)
        .and_call_original
    end

    context 'when resq for action step' do
      let(:action_block) { when_resq_for_action_step }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_action inner_step_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_two: 'Success',
              fail_one: nil,
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_action inner_step_one fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_two: nil,
              fail_one: 'Failure',
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_action inner_step_one error_handler fail_one] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_two: nil,
              fail_one: 'Failure',
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action step on_success leads to success track' do
      let(:action_block) { when_resq_for_action_step_on_success_to_success_track }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_action inner_step_one step_three] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_two: nil,
              fail_one: nil,
              step_three: 'Success'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_action inner_step_one fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_two: nil,
              fail_one: 'Failure',
              step_three: nil
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_action inner_step_one error_handler fail_one] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_two: nil,
              fail_one: 'Failure'
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action step on_failure leads to success track' do
      let(:action_block) { when_resq_for_action_step_on_failure_to_success_track }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_action inner_step_one step_two step_three] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_two: 'Success',
              fail_one: nil,
              step_three: 'Success'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_action inner_step_one step_three] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_two: nil,
              fail_one: nil,
              step_three: 'Success'
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_action inner_step_one error_handler fail_one] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_two: nil,
              fail_one: 'Failure',
              step_three: nil
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action step on_success leads to failure track' do
      let(:action_block) { when_resq_for_action_step_on_success_to_failure_track }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_action inner_step_one fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_two: nil,
              fail_one: 'Failure',
              step_three: nil,
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_action inner_step_one fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_two: nil,
              fail_one: 'Failure',
              step_three: nil,
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_action inner_step_one error_handler fail_one] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_two: nil,
              fail_one: 'Failure'
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action step on_failure leads to failure track' do
      let(:action_block) { when_resq_for_action_step_on_failure_to_failure_track }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_action inner_step_one step_two step_three] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_two: 'Success',
              fail_one: nil,
              step_three: 'Success',
              fail_two: nil,
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_action inner_step_one fail_two] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_two: nil,
              fail_one: nil,
              step_three: nil,
              fail_two: 'Failure'
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_action inner_step_one error_handler fail_one fail_two] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_two: nil,
              fail_one: 'Failure',
              step_three: nil,
              fail_two: 'Failure'
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action step complicated logic' do
      let(:action_block) { when_resq_for_action_step_complicated_logic }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_action inner_step_one step_two step_three] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_two: 'Success',
              fail_one: nil,
              step_three: 'Success',
              fail_two: nil,
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_action inner_step_one fail_two] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_two: nil,
              fail_one: nil,
              step_three: nil,
              fail_two: 'Failure'
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

      context 'when inner action raises an error' do
        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        context 'when fail_one step pass' do
          let(:railway_flow) { %i[step_action inner_step_one error_handler fail_one fail_two] }
          let(:param2) { true }
          let(:error_message) { 'Some error message' }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: nil,
                step_two: nil,
                fail_one: param2,
                step_three: nil,
                fail_two: 'Failure'
              },
              errors: {
                error_handler: [error_message]
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when fail_one step fail' do
          let(:railway_flow) { %i[step_action inner_step_one error_handler fail_one step_three] }
          let(:param2) { false }
          let(:error_message) { 'Some error message' }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              state: {
                result: nil,
                step_two: nil,
                fail_one: param2,
                step_three: 'Success',
                fail_two: nil
              },
              errors: {
                error_handler: [error_message]
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end
    end

    context 'when resq for action step on_success finish_him' do
      let(:action_block) { when_resq_for_action_step_on_success_finish_him }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_action inner_step_one] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_two: nil,
              fail_one: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_action inner_step_one fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_two: nil,
              fail_one: 'Failure'
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_action inner_step_one error_handler fail_one] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_two: nil,
              fail_one: 'Failure'
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action step on_failure finish_him' do
      let(:action_block) { when_resq_for_action_step_on_failure_finish_him }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_action inner_step_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_two: 'Success',
              fail_one: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_action inner_step_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_two: nil,
              fail_one: nil
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_action inner_step_one error_handler fail_one] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_two: nil,
              fail_one: 'Failure'
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action step with if condition' do
      let(:action_block) { when_resq_for_action_step_if_condition }

      context 'when condition passes' do
        let(:param2) { true }

        context 'when inner action passes' do
          let(:railway_flow) { %i[step_action inner_step_one step_two] }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              state: {
                result: true,
                step_two: 'Success',
                fail_one: nil
              },
              errors: {}
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when inner action fails' do
          let(:railway_flow) { %i[step_action inner_step_one fail_one] }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: false,
                step_two: nil,
                fail_one: 'Failure'
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

        context 'when inner action raises an error' do
          let(:railway_flow) { %i[step_action inner_step_one error_handler fail_one] }
          let(:error_message) { 'Some error message' }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: nil,
                step_two: nil,
                fail_one: 'Failure'
              },
              errors: {
                error_handler: [error_message]
              }
            }
          end

          before do
            allow(StubDummy).to receive(:call)
              .and_raise(
                ArgumentError,
                error_message
              )
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when conditon fails' do
        let(:param2) { false }
        let(:railway_flow) { %i[step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_two: 'Success',
              fail_one: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action step with unless condition' do
      let(:action_block) { when_resq_for_action_step_unless_condition }

      context 'when condition passes' do
        let(:param2) { false }

        context 'when inner action passes' do
          let(:railway_flow) { %i[step_action inner_step_one step_two] }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              state: {
                result: true,
                step_two: 'Success',
                fail_one: nil
              },
              errors: {}
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when inner action fails' do
          let(:railway_flow) { %i[step_action inner_step_one fail_one] }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: false,
                step_two: nil,
                fail_one: 'Failure'
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

        context 'when inner action raises an error' do
          let(:railway_flow) { %i[step_action inner_step_one error_handler fail_one] }
          let(:error_message) { 'Some error message' }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: nil,
                step_two: nil,
                fail_one: 'Failure'
              },
              errors: {
                error_handler: [error_message]
              }
            }
          end

          before do
            allow(StubDummy).to receive(:call)
              .and_raise(
                ArgumentError,
                error_message
              )
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when conditon fails' do
        let(:param2) { true }
        let(:railway_flow) { %i[step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_two: 'Success',
              fail_one: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action step on_failure leads to success track with if condition' do
      let(:action_block) { when_resq_for_action_step_on_failure_success_track_if_condition }

      context 'when condition passes' do
        let(:param2) { true }

        context 'when inner action passes' do
          let(:railway_flow) { %i[step_action inner_step_one step_two step_three] }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              state: {
                result: true,
                step_two: 'Success',
                fail_one: nil,
                step_three: 'Success',
                fail_two: nil
              },
              errors: {}
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when inner action fails' do
          let(:railway_flow) { %i[step_action inner_step_one step_three] }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              state: {
                result: false,
                step_two: nil,
                fail_one: nil,
                step_three: 'Success',
                fail_two: nil
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

        context 'when inner action raises an error' do
          let(:railway_flow) { %i[step_action inner_step_one error_handler fail_one fail_two] }
          let(:error_message) { 'Some error message' }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: nil,
                step_two: nil,
                fail_one: 'Failure',
                step_three: nil,
                fail_two: 'Failure'
              },
              errors: {
                error_handler: [error_message]
              }
            }
          end

          before do
            allow(StubDummy).to receive(:call)
              .and_raise(
                ArgumentError,
                error_message
              )
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when conditon fails' do
        let(:param2) { false }
        let(:railway_flow) { %i[step_two step_three] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_two: 'Success',
              fail_one: nil,
              step_three: 'Success',
              fail_two: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action step on_failure leads to success track with unless condition' do
      let(:action_block) { when_resq_for_action_step_on_success_failure_track_unless_condition }

      context 'when condition passes' do
        let(:param2) { false }

        context 'when inner action passes' do
          let(:railway_flow) { %i[step_action inner_step_one fail_two] }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: true,
                step_two: nil,
                fail_one: nil,
                step_three: nil,
                fail_two: 'Failure'
              },
              errors: {}
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when inner action fails' do
          let(:railway_flow) { %i[step_action inner_step_one fail_one fail_two] }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: false,
                step_two: nil,
                fail_one: 'Failure',
                step_three: nil,
                fail_two: 'Failure'
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

        context 'when inner action raises an error' do
          let(:railway_flow) { %i[step_action inner_step_one error_handler fail_one fail_two] }
          let(:error_message) { 'Some error message' }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: nil,
                step_two: nil,
                fail_one: 'Failure',
                step_three: nil,
                fail_two: 'Failure'
              },
              errors: {
                error_handler: [error_message]
              }
            }
          end

          before do
            allow(StubDummy).to receive(:call)
              .and_raise(
                ArgumentError,
                error_message
              )
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when conditon fails' do
        let(:param2) { true }
        let(:railway_flow) { %i[step_two step_three] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_two: 'Success',
              fail_one: nil,
              step_three: 'Success',
              fail_two: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action fail' do
      let(:action_block) { when_resq_for_action_fail }
      let(:param1) { false }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one fail_two fail_three] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_one: param1,
              step_two: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one fail_two fail_three] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_one: param1,
              step_two: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one error_handler fail_two fail_three] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: param1,
              step_two: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action fail on_success leads to success track' do
      let(:action_block) { when_resq_for_action_fail_on_success_to_success_track }
      let(:param1) { false }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one step_three] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_one: param1,
              step_two: nil,
              step_three: 'Success',
              fail_two: nil,
              fail_three: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one fail_two fail_three] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one error_handler fail_two fail_three] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action fail on_failure leads to success track' do
      let(:action_block) { when_resq_for_action_fail_on_failure_to_success_track }
      let(:param1) { false }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one fail_two fail_three] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one step_three] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_one: param1,
              step_two: nil,
              step_three: 'Success',
              fail_two: nil,
              fail_three: nil
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one error_handler fail_two fail_three] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action fail on_success leads to failure track' do
      let(:action_block) { when_resq_for_action_fail_on_success_to_failure_track }
      let(:param1) { false }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one fail_three] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: nil,
              fail_three: 'Failure'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one fail_two fail_three] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one error_handler fail_two fail_three] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action fail on_failure leads to failure track' do
      let(:action_block) { when_resq_for_action_fail_on_failure_to_failure_track }
      let(:param1) { false }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one fail_two fail_three] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one fail_three] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: nil,
              fail_three: 'Failure'
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one error_handler fail_two fail_three] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action fail on_success finish_him' do
      let(:action_block) { when_resq_for_action_fail_on_success_finish_him }
      let(:param1) { false }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: nil,
              fail_three: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one fail_two fail_three] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one error_handler fail_two fail_three] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action fail on_failure finish_him' do
      let(:action_block) { when_resq_for_action_fail_on_failure_finish_him }
      let(:param1) { false }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one fail_two fail_three] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: nil,
              fail_three: nil
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_one fail_one inner_step_one error_handler fail_two fail_three] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action fail with if condition' do
      let(:action_block) { when_resq_for_action_fail_if_condition }
      let(:param1) { false }

      context 'when condition passes' do
        let(:param2) { true }

        context 'when inner action passes' do
          let(:railway_flow) { %i[step_one fail_one inner_step_one fail_two fail_three] }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: true,
                step_one: param1,
                step_two: nil,
                step_three: nil,
                fail_two: 'Failure',
                fail_three: 'Failure'
              },
              errors: {}
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when inner action fails' do
          let(:railway_flow) { %i[step_one fail_one inner_step_one fail_two fail_three] }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: false,
                step_one: param1,
                step_two: nil,
                step_three: nil,
                fail_two: 'Failure',
                fail_three: 'Failure'
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

        context 'when inner action raises an error' do
          let(:railway_flow) { %i[step_one fail_one inner_step_one error_handler fail_two fail_three] }
          let(:error_message) { 'Some error message' }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: nil,
                step_one: param1,
                step_two: nil,
                step_three: nil,
                fail_two: 'Failure',
                fail_three: 'Failure'
              },
              errors: {
                error_handler: [error_message]
              }
            }
          end

          before do
            allow(StubDummy).to receive(:call)
              .and_raise(
                ArgumentError,
                error_message
              )
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when condition fails' do
        let(:param2) { false }

        let(:railway_flow) { %i[step_one fail_two fail_three] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action fail with unless condition' do
      let(:action_block) { when_resq_for_action_fail_unless_condition }
      let(:param1) { false }

      context 'when condition passes' do
        let(:param2) { false }

        context 'when inner action passes' do
          let(:railway_flow) { %i[step_one fail_one inner_step_one fail_two fail_three] }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: true,
                step_one: param1,
                step_two: nil,
                step_three: nil,
                fail_two: 'Failure',
                fail_three: 'Failure'
              },
              errors: {}
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when inner action fails' do
          let(:railway_flow) { %i[step_one fail_one inner_step_one fail_two fail_three] }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: false,
                step_one: param1,
                step_two: nil,
                step_three: nil,
                fail_two: 'Failure',
                fail_three: 'Failure'
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

        context 'when inner action raises an error' do
          let(:railway_flow) { %i[step_one fail_one inner_step_one error_handler fail_two fail_three] }
          let(:error_message) { 'Some error message' }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: nil,
                step_one: param1,
                step_two: nil,
                step_three: nil,
                fail_two: 'Failure',
                fail_three: 'Failure'
              },
              errors: {
                error_handler: [error_message]
              }
            }
          end

          before do
            allow(StubDummy).to receive(:call)
              .and_raise(
                ArgumentError,
                error_message
              )
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when condition fails' do
        let(:param2) { true }

        let(:railway_flow) { %i[step_one fail_two fail_three] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action fail on_failure leads to success track with if condition' do
      let(:action_block) { when_resq_for_action_fail_on_failure_success_track_if_condition }
      let(:param1) { false }

      context 'when condition passes' do
        let(:param2) { true }

        context 'when inner action passes' do
          let(:railway_flow) { %i[step_one fail_one inner_step_one fail_two fail_three] }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: true,
                step_one: param1,
                step_two: nil,
                step_three: nil,
                fail_two: 'Failure',
                fail_three: 'Failure'
              },
              errors: {}
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when inner action fails' do
          let(:railway_flow) { %i[step_one fail_one inner_step_one step_three] }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              state: {
                result: false,
                step_one: param1,
                step_two: nil,
                step_three: 'Success',
                fail_two: nil,
                fail_three: nil
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

        context 'when inner action raises an error' do
          let(:railway_flow) { %i[step_one fail_one inner_step_one error_handler fail_two fail_three] }
          let(:error_message) { 'Some error message' }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: nil,
                step_one: param1,
                step_two: nil,
                step_three: nil,
                fail_two: 'Failure',
                fail_three: 'Failure'
              },
              errors: {
                error_handler: [error_message]
              }
            }
          end

          before do
            allow(StubDummy).to receive(:call)
              .and_raise(
                ArgumentError,
                error_message
              )
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when condition fails' do
        let(:param2) { false }

        let(:railway_flow) { %i[step_one fail_two fail_three] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action fail on_success leads to failure track with unless condition' do
      let(:action_block) { when_resq_for_action_fail_on_success_failure_track_unless_condition }
      let(:param1) { false }

      context 'when condition passes' do
        let(:param2) { false }

        context 'when inner action passes' do
          let(:railway_flow) { %i[step_one fail_one inner_step_one fail_three] }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: true,
                step_one: param1,
                step_two: nil,
                step_three: nil,
                fail_two: nil,
                fail_three: 'Failure'
              },
              errors: {}
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when inner action fails' do
          let(:railway_flow) { %i[step_one fail_one inner_step_one fail_two fail_three] }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: false,
                step_one: param1,
                step_two: nil,
                step_three: nil,
                fail_two: 'Failure',
                fail_three: 'Failure'
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

        context 'when inner action raises an error' do
          let(:railway_flow) { %i[step_one fail_one inner_step_one error_handler fail_two fail_three] }
          let(:error_message) { 'Some error message' }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: nil,
                step_one: param1,
                step_two: nil,
                step_three: nil,
                fail_two: 'Failure',
                fail_three: 'Failure'
              },
              errors: {
                error_handler: [error_message]
              }
            }
          end

          before do
            allow(StubDummy).to receive(:call)
              .and_raise(
                ArgumentError,
                error_message
              )
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when condition fails' do
        let(:param2) { true }

        let(:railway_flow) { %i[step_one fail_two fail_three] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: param1,
              step_two: nil,
              step_three: nil,
              fail_two: 'Failure',
              fail_three: 'Failure'
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action pass' do
      let(:action_block) { when_resq_for_pass_action }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_one pass_one inner_step_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_one: 'Success',
              step_two: 'Success',
              fail_one: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_one pass_one inner_step_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_one: 'Success',
              step_two: 'Success',
              fail_one: nil
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_one pass_one inner_step_one error_handler fail_one] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: 'Success',
              step_two: nil,
              fail_one: 'Failure'
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action pass finish_him' do
      let(:action_block) { when_resq_for_pass_action_finish_him }

      context 'when inner action passes' do
        let(:railway_flow) { %i[step_one pass_one inner_step_one] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: true,
              step_one: 'Success',
              step_two: nil,
              fail_one: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
        it_behaves_like 'stub dummy was called'
      end

      context 'when inner action fails' do
        let(:railway_flow) { %i[step_one pass_one inner_step_one] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: false,
              step_one: 'Success',
              step_two: nil,
              fail_one: nil
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

      context 'when inner action raises an error' do
        let(:railway_flow) { %i[step_one pass_one inner_step_one error_handler fail_one] }
        let(:error_message) { 'Some error message' }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: 'Success',
              step_two: nil,
              fail_one: 'Failure'
            },
            errors: {
              error_handler: [error_message]
            }
          }
        end

        before do
          allow(StubDummy).to receive(:call)
            .and_raise(
              ArgumentError,
              error_message
            )
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action pass finish_him if condition' do
      let(:action_block) { when_resq_for_pass_finish_him_if_condition }

      context 'when condition passes' do
        let(:param2) { true }

        context 'when inner action passes' do
          let(:railway_flow) { %i[step_one pass_one inner_step_one] }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              state: {
                result: true,
                step_one: 'Success',
                step_two: nil,
                fail_one: nil
              },
              errors: {}
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when inner action fails' do
          let(:railway_flow) { %i[step_one pass_one inner_step_one] }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              state: {
                result: false,
                step_one: 'Success',
                step_two: nil,
                fail_one: nil
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

        context 'when inner action raises an error' do
          let(:railway_flow) { %i[step_one pass_one inner_step_one error_handler fail_one] }
          let(:error_message) { 'Some error message' }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: nil,
                step_one: 'Success',
                step_two: nil,
                fail_one: 'Failure'
              },
              errors: {
                error_handler: [error_message]
              }
            }
          end

          before do
            allow(StubDummy).to receive(:call)
              .and_raise(
                ArgumentError,
                error_message
              )
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when condition fails' do
        let(:param2) { false }
        let(:railway_flow) { %i[step_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: 'Success',
              step_two: 'Success',
              fail_one: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when resq for action pass finish_him unless condition' do
      let(:action_block) { when_resq_for_pass_finish_him_unless_condition }

      context 'when condition passes' do
        let(:param2) { false }

        context 'when inner action passes' do
          let(:railway_flow) { %i[step_one pass_one inner_step_one] }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              state: {
                result: true,
                step_one: 'Success',
                step_two: nil,
                fail_one: nil
              },
              errors: {}
            }
          end

          it_behaves_like 'check action state'
          it_behaves_like 'stub dummy was called'
        end

        context 'when inner action fails' do
          let(:railway_flow) { %i[step_one pass_one inner_step_one] }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              state: {
                result: false,
                step_one: 'Success',
                step_two: nil,
                fail_one: nil
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

        context 'when inner action raises an error' do
          let(:railway_flow) { %i[step_one pass_one inner_step_one error_handler fail_one] }
          let(:error_message) { 'Some error message' }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              state: {
                result: nil,
                step_one: 'Success',
                step_two: nil,
                fail_one: 'Failure'
              },
              errors: {
                error_handler: [error_message]
              }
            }
          end

          before do
            allow(StubDummy).to receive(:call)
              .and_raise(
                ArgumentError,
                error_message
              )
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when condition fails' do
        let(:param2) { true }
        let(:railway_flow) { %i[step_one step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: nil,
              step_one: 'Success',
              step_two: 'Success',
              fail_one: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end
  end
end
