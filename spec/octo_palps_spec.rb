# frozen_string_literal: true

RSpec.describe 'Decouplio::Action octo palps' do
  include_context 'with basic spec setup'

  describe 'octo_palps' do
    let(:input_params) do
      {
        strategy_one_key: strategy_one_key,
        strategy_two_key: strategy_two_key,
        process_strategy_two: process_strategy_two,
        process_step_three: process_step_three,
        process_step_four: process_step_four,
        param1: param1,
        param2: param2,
        param3: param3,
        param4: param4,
        param5: param5,
        param6: param6,
        final: final
      }
    end

    let(:param1) { 'param1' }
    let(:param2) { 'param2' }
    let(:param3) { 'param3' }
    let(:param4) { 'param4' }
    let(:param5) { 'param5' }
    let(:param6) { 'param6' }
    let(:final) { 'Final' }
    let(:strategy_two_key) { 'not_existing_strategy' }
    let(:process_step_four) { true }
    let(:process_step_three) { true }

    describe 'on_success' do
      let(:action_block) { octo_palps }

      context 'when octo1' do
        context 'when octo1 fails' do
          let(:strategy_one_key) { :octo1 }
          let(:process_strategy_two) { false }
          let(:process_step_three) { true }
          let(:param3) { false }
          let(:railway_flow) do
            %i[
              assign_strategy_one_key
              strategy_one
              step_one
              step_three
              strategy_failure
            ]
          end
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                octo_key: strategy_one_key,
                strategy_two_key: strategy_two_key,
                step_one: param1,
                step_two: nil,
                step_three: param3,
                step_four: nil,
                step_five: nil,
                step_six: nil,
                process_strategy_two: false,
                result: nil,
                strategy_failure_handled: true
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when octo1 passes and strategy two should not be processed' do
          let(:strategy_one_key) { :octo1 }
          let(:process_strategy_two) { false }
          let(:process_step_three) { nil }
          let(:railway_flow) do
            %i[
              assign_strategy_one_key
              strategy_one
              step_one
              step_four
              final_step
            ]
          end
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: {},
              state: {
                octo_key: strategy_one_key,
                strategy_two_key: strategy_two_key,
                step_one: param1,
                step_two: nil,
                step_three: nil,
                step_four: param4,
                step_five: nil,
                step_six: nil,
                process_strategy_two: false,
                result: final,
                strategy_failure_handled: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when strategy two should be processed' do
          context 'when octo1 fails' do
            let(:strategy_one_key) { :octo1 }
            let(:strategy_two_key) { :octo4 }
            let(:process_strategy_two) { true }
            let(:process_step_three) { true }
            let(:param3) { false }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                strategy_one
                step_one
                step_three
                strategy_failure
              ]
            end
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  octo_key: strategy_one_key,
                  strategy_two_key: strategy_two_key,
                  step_one: param1,
                  step_two: nil,
                  step_three: param3,
                  step_four: nil,
                  step_five: nil,
                  step_six: nil,
                  process_strategy_two: true,
                  result: nil,
                  strategy_failure_handled: true
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when octo1 passes' do
            context 'when octo4' do
              let(:strategy_one_key) { :octo1 }
              let(:strategy_two_key) { :octo4 }
              let(:process_strategy_two) { true }

              context 'when step_five passes' do
                let(:process_step_three) { nil }
                let(:process_step_four) { true }
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    strategy_one
                    step_one
                    step_four
                    strategy_two
                    step_five
                    final_step
                  ]
                end
                let(:expected_state) do
                  {
                    action_status: :success,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      octo_key: strategy_one_key,
                      strategy_two_key: strategy_two_key,
                      step_one: param1,
                      step_two: nil,
                      step_three: nil,
                      step_four: param4,
                      step_five: param5,
                      step_six: nil,
                      process_strategy_two: true,
                      result: final,
                      strategy_failure_handled: nil
                    }
                  }
                end

                it_behaves_like 'check action state'
              end

              context 'when step_five fails' do
                context 'when step_four should be precessed' do
                  let(:param5) { false }
                  let(:process_step_three) { true }
                  let(:process_step_four) { true }
                  let(:railway_flow) do
                    %i[
                      assign_strategy_one_key
                      strategy_one
                      step_one
                      step_three
                      step_four
                      strategy_two
                      step_five
                      step_four
                      strategy_failure
                    ]
                  end
                  let(:expected_state) do
                    {
                      action_status: :failure,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        octo_key: strategy_one_key,
                        strategy_two_key: strategy_two_key,
                        step_one: param1,
                        step_two: nil,
                        step_three: param3,
                        step_four: param4 * 2,
                        step_five: param5,
                        step_six: nil,
                        process_strategy_two: true,
                        result: nil,
                        strategy_failure_handled: true
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end

                context 'when step_four should not be processed' do
                  let(:param5) { false }
                  let(:process_step_three) { true }
                  let(:process_step_four) { false }
                  let(:railway_flow) do
                    %i[
                      assign_strategy_one_key
                      strategy_one
                      step_one
                      step_three
                      step_four
                      strategy_two
                      step_five
                      strategy_failure
                    ]
                  end
                  let(:expected_state) do
                    {
                      action_status: :failure,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        octo_key: strategy_one_key,
                        strategy_two_key: strategy_two_key,
                        step_one: param1,
                        step_two: nil,
                        step_three: param3,
                        step_four: param4,
                        step_five: param5,
                        step_six: nil,
                        process_strategy_two: true,
                        result: nil,
                        strategy_failure_handled: true
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end
              end
            end

            context 'when octo5' do
              let(:strategy_one_key) { :octo1 }
              let(:strategy_two_key) { :octo5 }
              let(:process_strategy_two) { true }

              context 'when step five fails' do
                let(:process_step_three) { nil }
                let(:param5) { nil }
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    strategy_one
                    step_one
                    step_four
                    strategy_two
                    step_five
                    step_six
                    strategy_failure
                  ]
                end
                let(:expected_state) do
                  {
                    action_status: :failure,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      octo_key: strategy_one_key,
                      strategy_two_key: strategy_two_key,
                      step_one: param1,
                      step_two: nil,
                      step_three: nil,
                      step_four: param4,
                      step_five: param5,
                      step_six: param6,
                      process_strategy_two: true,
                      result: nil,
                      strategy_failure_handled: true
                    }
                  }
                end

                it_behaves_like 'check action state'
              end

              context 'when step five pass' do
                let(:process_step_three) { nil }
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    strategy_one
                    step_one
                    step_four
                    strategy_two
                    step_five
                    step_four
                    final_step
                  ]
                end
                let(:expected_state) do
                  {
                    action_status: :success,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      octo_key: strategy_one_key,
                      strategy_two_key: strategy_two_key,
                      step_one: param1,
                      step_two: nil,
                      step_three: nil,
                      step_four: param4 * 2,
                      step_five: param5,
                      step_six: nil,
                      process_strategy_two: true,
                      result: final,
                      strategy_failure_handled: nil
                    }
                  }
                end

                it_behaves_like 'check action state'
              end
            end
          end
        end
      end

      context 'when octo2' do
        context 'when octo2 fails' do
          let(:strategy_one_key) { :octo2 }

          context 'when step_two fails' do
            let(:process_strategy_two) { false }
            let(:param2) { nil }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                strategy_one
                step_two
                strategy_failure
              ]
            end
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  octo_key: strategy_one_key,
                  strategy_two_key: 'not_existing_strategy',
                  step_one: nil,
                  step_two: nil,
                  step_three: nil,
                  step_four: nil,
                  step_five: nil,
                  step_six: nil,
                  process_strategy_two: false,
                  result: nil,
                  strategy_failure_handled: true
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when step_three fails' do
            let(:process_strategy_two) { false }
            let(:param3) { nil }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                strategy_one
                step_two
                step_three
                strategy_failure
              ]
            end
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  octo_key: strategy_one_key,
                  strategy_two_key: 'not_existing_strategy',
                  step_one: nil,
                  step_two: param2,
                  step_three: nil,
                  step_four: nil,
                  step_five: nil,
                  step_six: nil,
                  process_strategy_two: false,
                  result: nil,
                  strategy_failure_handled: true
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end

        context 'when octo2 passes' do
          let(:strategy_one_key) { :octo2 }
          let(:process_strategy_two) { false }
          let(:railway_flow) do
            %i[
              assign_strategy_one_key
              strategy_one
              step_two
              step_three
              final_step
            ]
          end
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: {},
              state: {
                octo_key: strategy_one_key,
                strategy_two_key: 'not_existing_strategy',
                step_one: nil,
                step_two: param2,
                step_three: param3,
                step_four: nil,
                step_five: nil,
                step_six: nil,
                process_strategy_two: false,
                result: final,
                strategy_failure_handled: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when strategy two should be processed' do
          context 'when octo2 fails' do
            let(:strategy_one_key) { :octo2 }
            let(:strategy_two_key) { :octo4 }
            let(:process_strategy_two) { true }
            let(:process_step_three) { true }
            let(:param3) { nil }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                strategy_one
                step_two
                step_three
                strategy_failure
              ]
            end
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  octo_key: strategy_one_key,
                  strategy_two_key: strategy_two_key,
                  step_one: nil,
                  step_two: param2,
                  step_three: nil,
                  step_four: nil,
                  step_five: nil,
                  step_six: nil,
                  process_strategy_two: true,
                  result: nil,
                  strategy_failure_handled: true
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when octo2 passes' do
            context 'when octo4' do
              let(:strategy_one_key) { :octo2 }
              let(:strategy_two_key) { :octo4 }
              let(:process_strategy_two) { true }

              context 'when step_five passes' do
                let(:process_step_four) { true }
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    strategy_one
                    step_two
                    step_three
                    strategy_two
                    step_five
                    final_step
                  ]
                end
                let(:expected_state) do
                  {
                    action_status: :success,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      octo_key: strategy_one_key,
                      strategy_two_key: strategy_two_key,
                      step_one: nil,
                      step_two: param2,
                      step_three: param3,
                      step_four: nil,
                      step_five: param5,
                      step_six: nil,
                      process_strategy_two: true,
                      result: final,
                      strategy_failure_handled: nil
                    }
                  }
                end

                it_behaves_like 'check action state'
              end

              context 'when step_five fails' do
                context 'when step_four should be precessed' do
                  let(:param5) { nil }
                  let(:process_step_three) { true }
                  let(:process_step_four) { true }
                  let(:railway_flow) do
                    %i[
                      assign_strategy_one_key
                      strategy_one
                      step_two
                      step_three
                      strategy_two
                      step_five
                      step_four
                      strategy_failure
                    ]
                  end
                  let(:expected_state) do
                    {
                      action_status: :failure,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        octo_key: strategy_one_key,
                        strategy_two_key: strategy_two_key,
                        step_one: nil,
                        step_two: param2,
                        step_three: param3,
                        step_four: param4,
                        step_five: nil,
                        step_six: nil,
                        process_strategy_two: true,
                        result: nil,
                        strategy_failure_handled: true
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end

                context 'when step_four should not be processed' do
                  let(:param5) { nil }
                  let(:process_step_four) { false }
                  let(:railway_flow) do
                    %i[
                      assign_strategy_one_key
                      strategy_one
                      step_two
                      step_three
                      strategy_two
                      step_five
                      strategy_failure
                    ]
                  end
                  let(:expected_state) do
                    {
                      action_status: :failure,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        octo_key: strategy_one_key,
                        strategy_two_key: strategy_two_key,
                        step_one: nil,
                        step_two: param2,
                        step_three: param3,
                        step_four: nil,
                        step_five: nil,
                        step_six: nil,
                        process_strategy_two: true,
                        result: nil,
                        strategy_failure_handled: true
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end
              end
            end

            context 'when octo5' do
              let(:strategy_one_key) { :octo2 }
              let(:strategy_two_key) { :octo5 }
              let(:process_strategy_two) { true }

              context 'when step five fails' do
                let(:param5) { nil }
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    strategy_one
                    step_two
                    step_three
                    strategy_two
                    step_five
                    step_six
                    strategy_failure
                  ]
                end
                let(:expected_state) do
                  {
                    action_status: :failure,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      octo_key: strategy_one_key,
                      strategy_two_key: strategy_two_key,
                      step_one: nil,
                      step_two: param2,
                      step_three: param3,
                      step_four: nil,
                      step_five: param5,
                      step_six: param6,
                      process_strategy_two: true,
                      result: nil,
                      strategy_failure_handled: true
                    }
                  }
                end

                it_behaves_like 'check action state'
              end

              context 'when step five pass' do
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    strategy_one
                    step_two
                    step_three
                    strategy_two
                    step_five
                    step_four
                    final_step
                  ]
                end
                let(:expected_state) do
                  {
                    action_status: :success,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      octo_key: strategy_one_key,
                      strategy_two_key: strategy_two_key,
                      step_one: nil,
                      step_two: param2,
                      step_three: param3,
                      step_four: param4,
                      step_five: param5,
                      step_six: nil,
                      process_strategy_two: true,
                      result: final,
                      strategy_failure_handled: nil
                    }
                  }
                end

                it_behaves_like 'check action state'
              end
            end
          end
        end
      end

      context 'when octo3' do
        context 'when octo3 fails' do
          let(:strategy_one_key) { :octo3 }

          context 'when step_one fails' do
            let(:process_strategy_two) { false }
            let(:param1) { nil }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                strategy_one
                step_one
                strategy_failure
              ]
            end
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  octo_key: strategy_one_key,
                  strategy_two_key: 'not_existing_strategy',
                  step_one: nil,
                  step_two: nil,
                  step_three: nil,
                  step_four: nil,
                  step_five: nil,
                  step_six: nil,
                  process_strategy_two: false,
                  result: nil,
                  strategy_failure_handled: true
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when step_four fails' do
            let(:process_strategy_two) { false }
            let(:param4) { nil }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                strategy_one
                step_one
                step_four
                strategy_failure
              ]
            end
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  octo_key: strategy_one_key,
                  strategy_two_key: 'not_existing_strategy',
                  step_one: param1,
                  step_two: nil,
                  step_three: nil,
                  step_four: nil,
                  step_five: nil,
                  step_six: nil,
                  process_strategy_two: false,
                  result: nil,
                  strategy_failure_handled: true
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when assign_second_strategy fails' do
            let(:strategy_two_key) { nil }
            let(:process_strategy_two) { false }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                strategy_one
                step_one
                step_four
                assign_second_strategy
                strategy_failure
              ]
            end
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  octo_key: strategy_one_key,
                  strategy_two_key: nil,
                  step_one: param1,
                  step_two: nil,
                  step_three: nil,
                  step_four: param4,
                  step_five: nil,
                  step_six: nil,
                  process_strategy_two: false,
                  result: nil,
                  strategy_failure_handled: true
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end

        context 'when octo3 passes' do
          let(:strategy_one_key) { :octo3 }
          let(:strategy_two_key) { :octo4 }
          let(:process_strategy_two) { false }
          let(:railway_flow) do
            %i[
              assign_strategy_one_key
              strategy_one
              step_one
              step_four
              assign_second_strategy
              final_step
            ]
          end
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: {},
              state: {
                octo_key: strategy_one_key,
                strategy_two_key: strategy_two_key,
                step_one: param1,
                step_two: nil,
                step_three: nil,
                step_four: param4,
                step_five: nil,
                step_six: nil,
                process_strategy_two: false,
                result: final,
                strategy_failure_handled: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when strategy two should be processed' do
          context 'when octo3 fails' do
            let(:strategy_one_key) { :octo3 }
            let(:strategy_two_key) { :octo4 }
            let(:process_strategy_two) { true }
            let(:process_step_three) { true }
            let(:param4) { nil }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                strategy_one
                step_one
                step_four
                strategy_failure
              ]
            end
            let(:expected_state) do
              {
                action_status: :failure,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  octo_key: strategy_one_key,
                  strategy_two_key: strategy_two_key,
                  step_one: param1,
                  step_two: nil,
                  step_three: nil,
                  step_four: nil,
                  step_five: nil,
                  step_six: nil,
                  process_strategy_two: true,
                  result: nil,
                  strategy_failure_handled: true
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when octo3 passes' do
            context 'when octo4' do
              let(:strategy_one_key) { :octo3 }
              let(:strategy_two_key) { :octo4 }
              let(:process_strategy_two) { true }

              context 'when step_five passes' do
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    strategy_one
                    step_one
                    step_four
                    assign_second_strategy
                    strategy_two
                    step_five
                    final_step
                  ]
                end
                let(:expected_state) do
                  {
                    action_status: :success,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      octo_key: strategy_one_key,
                      strategy_two_key: strategy_two_key,
                      step_one: param1,
                      step_two: nil,
                      step_three: nil,
                      step_four: param4,
                      step_five: param5,
                      step_six: nil,
                      process_strategy_two: true,
                      result: final,
                      strategy_failure_handled: nil
                    }
                  }
                end

                it_behaves_like 'check action state'
              end

              context 'when step_five fails' do
                context 'when step_four should be precessed' do
                  let(:param5) { nil }
                  let(:process_step_four) { true }
                  let(:railway_flow) do
                    %i[
                      assign_strategy_one_key
                      strategy_one
                      step_one
                      step_four
                      assign_second_strategy
                      strategy_two
                      step_five
                      step_four
                      strategy_failure
                    ]
                  end
                  let(:expected_state) do
                    {
                      action_status: :failure,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        octo_key: strategy_one_key,
                        strategy_two_key: strategy_two_key,
                        step_one: param1,
                        step_two: nil,
                        step_three: nil,
                        step_four: param4 * 2,
                        step_five: param5,
                        step_six: nil,
                        process_strategy_two: true,
                        result: nil,
                        strategy_failure_handled: true
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end

                context 'when step_four should not be processed' do
                  let(:param5) { nil }
                  let(:process_step_four) { false }
                  let(:railway_flow) do
                    %i[
                      assign_strategy_one_key
                      strategy_one
                      step_one
                      step_four
                      assign_second_strategy
                      strategy_two
                      step_five
                      strategy_failure
                    ]
                  end
                  let(:expected_state) do
                    {
                      action_status: :failure,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        octo_key: strategy_one_key,
                        strategy_two_key: strategy_two_key,
                        step_one: param1,
                        step_two: nil,
                        step_three: nil,
                        step_four: param4,
                        step_five: nil,
                        step_six: nil,
                        process_strategy_two: true,
                        result: nil,
                        strategy_failure_handled: true
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end
              end
            end

            context 'when octo5' do
              let(:strategy_one_key) { :octo3 }
              let(:strategy_two_key) { :octo5 }
              let(:process_strategy_two) { true }

              context 'when step five fails' do
                let(:param5) { nil }
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    strategy_one
                    step_one
                    step_four
                    assign_second_strategy
                    strategy_two
                    step_five
                    step_six
                    strategy_failure
                  ]
                end
                let(:expected_state) do
                  {
                    action_status: :failure,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      octo_key: strategy_one_key,
                      strategy_two_key: strategy_two_key,
                      step_one: param1,
                      step_two: nil,
                      step_three: nil,
                      step_four: param4,
                      step_five: param5,
                      step_six: param6,
                      process_strategy_two: true,
                      result: nil,
                      strategy_failure_handled: true
                    }
                  }
                end

                it_behaves_like 'check action state'
              end

              context 'when step five pass' do
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    strategy_one
                    step_one
                    step_four
                    assign_second_strategy
                    strategy_two
                    step_five
                    step_four
                    final_step
                  ]
                end
                let(:expected_state) do
                  {
                    action_status: :success,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      octo_key: strategy_one_key,
                      strategy_two_key: strategy_two_key,
                      step_one: param1,
                      step_two: nil,
                      step_three: nil,
                      step_four: param4 * 2,
                      step_five: param5,
                      step_six: nil,
                      process_strategy_two: true,
                      result: final,
                      strategy_failure_handled: nil
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

  describe 'when octo palps inner on_success and on_failure' do
    let(:action_block) { when_octo_palps_inner_on_success_on_failure }
    let(:step_error_message) { 'Step error message' }
    let(:fail_error_message) { 'Fail error message' }
    let(:pass_error_message) { 'Pass error message' }
    let(:input_params) do
      {
        param1: param1,
        param2: param2,
        param3: param3,
        param4: param4,
        param5: param5,
        param6: param6,
        param7: param7,
        param8: param8,
        octo_key: octo_key
      }
    end

    let(:param1) { nil }
    let(:param2) { nil }
    let(:param3) { nil }
    let(:param4) { nil }
    let(:param5) { nil }
    let(:param6) { nil }
    let(:param7) { nil }
    let(:param8) { nil }
    let(:octo_key) { nil }

    context 'when step_one success' do
      context 'when octo_key octo_key1' do
        let(:octo_key) { :octo_key1 }

        context 'when palp_step success' do
          context 'when pass_one success' do
            let(:railway_flow) { %i[step_one octo_name palp_step pass_one] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:param5) { -> { true } }
            let(:param6) { -> { true } }
            let(:param7) { -> { true } }
            let(:param8) { -> { true } }
            let(:expected_state) do
              {
                action_status: :success,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  fail_one: nil,
                  palp_step: true,
                  palp_fail: nil,
                  palp_pass: nil,
                  step_two: nil,
                  pass_one: true,
                  fail_two: nil,
                  error_handler_palp_step: nil,
                  error_handler_palp_fail: nil,
                  error_handler_palp_pass: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when pass_one failure' do
            let(:railway_flow) { %i[step_one octo_name palp_step pass_one] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:param5) { -> { true } }
            let(:param6) { -> { true } }
            let(:param7) { -> { false } }
            let(:param8) { -> { true } }
            let(:expected_state) do
              {
                action_status: :success,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  fail_one: nil,
                  palp_step: true,
                  palp_fail: nil,
                  palp_pass: nil,
                  step_two: nil,
                  pass_one: false,
                  fail_two: nil,
                  error_handler_palp_step: nil,
                  error_handler_palp_fail: nil,
                  error_handler_palp_pass: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end
        end

        context 'when palp_step failure' do
          context 'when palp_fail success' do
            context 'when palp_pass success' do
              context 'when step_two success' do
                context 'when pass_one success' do
                  let(:railway_flow) { %i[step_one octo_name palp_step palp_fail palp_pass step_two pass_one] }
                  let(:param1) { -> { true } }
                  let(:param2) { -> { true } }
                  let(:param3) { -> { false } }
                  let(:param4) { -> { true } }
                  let(:param5) { -> { true } }
                  let(:param6) { -> { true } }
                  let(:param7) { -> { true } }
                  let(:param8) { -> { true } }
                  let(:expected_state) do
                    {
                      action_status: :success,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        step_one: true,
                        fail_one: nil,
                        palp_step: false,
                        palp_fail: true,
                        palp_pass: true,
                        step_two: true,
                        pass_one: true,
                        fail_two: nil,
                        error_handler_palp_step: nil,
                        error_handler_palp_fail: nil,
                        error_handler_palp_pass: nil
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end

                context 'when pass_one failues' do
                  let(:railway_flow) { %i[step_one octo_name palp_step palp_fail palp_pass step_two pass_one] }
                  let(:param1) { -> { true } }
                  let(:param2) { -> { true } }
                  let(:param3) { -> { false } }
                  let(:param4) { -> { true } }
                  let(:param5) { -> { true } }
                  let(:param6) { -> { true } }
                  let(:param7) { -> { false } }
                  let(:param8) { -> { true } }
                  let(:expected_state) do
                    {
                      action_status: :success,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        step_one: true,
                        fail_one: nil,
                        palp_step: false,
                        palp_fail: true,
                        palp_pass: true,
                        step_two: true,
                        pass_one: false,
                        fail_two: nil,
                        error_handler_palp_step: nil,
                        error_handler_palp_fail: nil,
                        error_handler_palp_pass: nil
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end
              end

              context 'when step_two failure' do
                context 'when fail_two success' do
                  let(:railway_flow) { %i[step_one octo_name palp_step palp_fail palp_pass step_two fail_two] }
                  let(:param1) { -> { true } }
                  let(:param2) { -> { true } }
                  let(:param3) { -> { false } }
                  let(:param4) { -> { true } }
                  let(:param5) { -> { true } }
                  let(:param6) { -> { false } }
                  let(:param7) { -> { true } }
                  let(:param8) { -> { true } }
                  let(:expected_state) do
                    {
                      action_status: :failure,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        step_one: true,
                        fail_one: nil,
                        palp_step: false,
                        palp_fail: true,
                        palp_pass: true,
                        step_two: false,
                        pass_one: nil,
                        fail_two: true,
                        error_handler_palp_step: nil,
                        error_handler_palp_fail: nil,
                        error_handler_palp_pass: nil
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end

                context 'when fail_two failure' do
                  let(:railway_flow) { %i[step_one octo_name palp_step palp_fail palp_pass step_two fail_two] }
                  let(:param1) { -> { true } }
                  let(:param2) { -> { true } }
                  let(:param3) { -> { false } }
                  let(:param4) { -> { true } }
                  let(:param5) { -> { true } }
                  let(:param6) { -> { false } }
                  let(:param7) { -> { true } }
                  let(:param8) { -> { false } }
                  let(:expected_state) do
                    {
                      action_status: :failure,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        step_one: true,
                        fail_one: nil,
                        palp_step: false,
                        palp_fail: true,
                        palp_pass: true,
                        step_two: false,
                        pass_one: nil,
                        fail_two: false,
                        error_handler_palp_step: nil,
                        error_handler_palp_fail: nil,
                        error_handler_palp_pass: nil
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end
              end
            end

            context 'when palp_pass failure' do
              context 'when step_two success' do
                context 'when pass_one success' do
                  let(:railway_flow) { %i[step_one octo_name palp_step palp_fail palp_pass step_two pass_one] }
                  let(:param1) { -> { true } }
                  let(:param2) { -> { true } }
                  let(:param3) { -> { false } }
                  let(:param4) { -> { true } }
                  let(:param5) { -> { false } }
                  let(:param6) { -> { true } }
                  let(:param7) { -> { true } }
                  let(:param8) { -> { true } }
                  let(:expected_state) do
                    {
                      action_status: :success,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        step_one: true,
                        fail_one: nil,
                        palp_step: false,
                        palp_fail: true,
                        palp_pass: false,
                        step_two: true,
                        pass_one: true,
                        fail_two: nil,
                        error_handler_palp_step: nil,
                        error_handler_palp_fail: nil,
                        error_handler_palp_pass: nil
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end

                context 'when pass_one failues' do
                  let(:railway_flow) { %i[step_one octo_name palp_step palp_fail palp_pass step_two pass_one] }
                  let(:param1) { -> { true } }
                  let(:param2) { -> { true } }
                  let(:param3) { -> { false } }
                  let(:param4) { -> { true } }
                  let(:param5) { -> { false } }
                  let(:param6) { -> { true } }
                  let(:param7) { -> { false } }
                  let(:param8) { -> { true } }
                  let(:expected_state) do
                    {
                      action_status: :success,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        step_one: true,
                        fail_one: nil,
                        palp_step: false,
                        palp_fail: true,
                        palp_pass: false,
                        step_two: true,
                        pass_one: false,
                        fail_two: nil,
                        error_handler_palp_step: nil,
                        error_handler_palp_fail: nil,
                        error_handler_palp_pass: nil
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end
              end

              context 'when step_two failure' do
                context 'when fail_two success' do
                  let(:railway_flow) { %i[step_one octo_name palp_step palp_fail palp_pass step_two fail_two] }
                  let(:param1) { -> { true } }
                  let(:param2) { -> { true } }
                  let(:param3) { -> { false } }
                  let(:param4) { -> { true } }
                  let(:param5) { -> { true } }
                  let(:param6) { -> { false } }
                  let(:param7) { -> { true } }
                  let(:param8) { -> { true } }
                  let(:expected_state) do
                    {
                      action_status: :failure,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        step_one: true,
                        fail_one: nil,
                        palp_step: false,
                        palp_fail: true,
                        palp_pass: true,
                        step_two: false,
                        pass_one: nil,
                        fail_two: true,
                        error_handler_palp_step: nil,
                        error_handler_palp_fail: nil,
                        error_handler_palp_pass: nil
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end

                context 'when fail_two failure' do
                  let(:railway_flow) { %i[step_one octo_name palp_step palp_fail palp_pass step_two fail_two] }
                  let(:param1) { -> { true } }
                  let(:param2) { -> { true } }
                  let(:param3) { -> { false } }
                  let(:param4) { -> { true } }
                  let(:param5) { -> { true } }
                  let(:param6) { -> { false } }
                  let(:param7) { -> { true } }
                  let(:param8) { -> { false } }
                  let(:expected_state) do
                    {
                      action_status: :failure,
                      railway_flow: railway_flow,
                      errors: {},
                      state: {
                        step_one: true,
                        fail_one: nil,
                        palp_step: false,
                        palp_fail: true,
                        palp_pass: true,
                        step_two: false,
                        pass_one: nil,
                        fail_two: false,
                        error_handler_palp_step: nil,
                        error_handler_palp_fail: nil,
                        error_handler_palp_pass: nil
                      }
                    }
                  end

                  it_behaves_like 'check action state'
                end
              end
            end
          end

          context 'when palp_fail failure' do
            context 'when fail_two success' do
              let(:railway_flow) { %i[step_one octo_name palp_step palp_fail fail_two] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { false } }
              let(:param4) { -> { false } }
              let(:param5) { -> { true } }
              let(:param6) { -> { true } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: false,
                    palp_fail: false,
                    palp_pass: nil,
                    step_two: nil,
                    pass_one: nil,
                    fail_two: true,
                    error_handler_palp_step: nil,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when fail_two failure' do
              let(:railway_flow) { %i[step_one octo_name palp_step palp_fail fail_two] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { false } }
              let(:param4) { -> { false } }
              let(:param5) { -> { true } }
              let(:param6) { -> { true } }
              let(:param7) { -> { true } }
              let(:param8) { -> { false } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: false,
                    palp_fail: false,
                    palp_pass: nil,
                    step_two: nil,
                    pass_one: nil,
                    fail_two: false,
                    error_handler_palp_step: nil,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end
          end

          context 'when palp_fail raises an error' do
            context 'when fail_two success' do
              let(:railway_flow) { %i[step_one octo_name palp_step palp_fail error_handler_palp_fail fail_two] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { false } }
              let(:param4) { -> { raise ArgumentError, fail_error_message } }
              let(:param5) { -> { true } }
              let(:param6) { -> { true } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: false,
                    palp_fail: nil,
                    palp_pass: nil,
                    step_two: nil,
                    pass_one: nil,
                    fail_two: true,
                    error_handler_palp_step: nil,
                    error_handler_palp_fail: fail_error_message,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when fail_two failure' do
              let(:railway_flow) { %i[step_one octo_name palp_step palp_fail error_handler_palp_fail fail_two] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { false } }
              let(:param4) { -> { raise ArgumentError, fail_error_message } }
              let(:param5) { -> { true } }
              let(:param6) { -> { true } }
              let(:param7) { -> { true } }
              let(:param8) { -> { false } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: false,
                    palp_fail: nil,
                    palp_pass: nil,
                    step_two: nil,
                    pass_one: nil,
                    fail_two: false,
                    error_handler_palp_step: nil,
                    error_handler_palp_fail: fail_error_message,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end
          end
        end
      end

      context 'when octo_key octo_key2' do
        let(:octo_key) { :octo_key2 }

        context 'when palp_pass success' do
          context 'when palp_step success' do
            context 'when step_two success' do
              let(:railway_flow) { %i[step_one octo_name palp_pass palp_step step_two pass_one] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { true } }
              let(:param5) { -> { true } }
              let(:param6) { -> { true } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :success,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: true,
                    palp_fail: nil,
                    palp_pass: true,
                    step_two: true,
                    pass_one: true,
                    fail_two: nil,
                    error_handler_palp_step: nil,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when step_two failure' do
              let(:railway_flow) { %i[step_one octo_name palp_pass palp_step step_two fail_two] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { true } }
              let(:param5) { -> { true } }
              let(:param6) { -> { false } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: true,
                    palp_fail: nil,
                    palp_pass: true,
                    step_two: false,
                    pass_one: nil,
                    fail_two: true,
                    error_handler_palp_step: nil,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end
          end

          context 'when palp_step failure' do
            let(:railway_flow) { %i[step_one octo_name palp_pass palp_step pass_one] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { false } }
            let(:param4) { -> { true } }
            let(:param5) { -> { true } }
            let(:param6) { -> { true } }
            let(:param7) { -> { true } }
            let(:param8) { -> { true } }
            let(:expected_state) do
              {
                action_status: :success,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  fail_one: nil,
                  palp_step: false,
                  palp_fail: nil,
                  palp_pass: true,
                  step_two: nil,
                  pass_one: true,
                  fail_two: nil,
                  error_handler_palp_step: nil,
                  error_handler_palp_fail: nil,
                  error_handler_palp_pass: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when palp_step raises an error' do
            context 'when palp_fail success' do
              let(:railway_flow) do
                %i[
                  step_one
                  octo_name
                  palp_pass
                  palp_step
                  error_handler_palp_step
                  palp_fail
                  fail_two
                ]
              end
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { raise ArgumentError, step_error_message } }
              let(:param4) { -> { true } }
              let(:param5) { -> { true } }
              let(:param6) { -> { true } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: nil,
                    palp_fail: true,
                    palp_pass: true,
                    step_two: nil,
                    pass_one: nil,
                    fail_two: true,
                    error_handler_palp_step: step_error_message,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when palp_fail failure' do
              let(:railway_flow) do
                %i[
                  step_one
                  octo_name
                  palp_pass
                  palp_step
                  error_handler_palp_step
                  palp_fail
                  step_two
                  pass_one
                ]
              end
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { raise ArgumentError, step_error_message } }
              let(:param4) { -> { false } }
              let(:param5) { -> { true } }
              let(:param6) { -> { true } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :success,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: nil,
                    palp_fail: false,
                    palp_pass: true,
                    step_two: true,
                    pass_one: true,
                    fail_two: nil,
                    error_handler_palp_step: step_error_message,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end
          end
        end

        context 'when palp_pass failure' do
          context 'when palp_step success' do
            context 'when step_two success' do
              let(:railway_flow) { %i[step_one octo_name palp_pass palp_step step_two pass_one] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { true } }
              let(:param5) { -> { false } }
              let(:param6) { -> { true } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :success,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: true,
                    palp_fail: nil,
                    palp_pass: false,
                    step_two: true,
                    pass_one: true,
                    fail_two: nil,
                    error_handler_palp_step: nil,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when step_two failure' do
              let(:railway_flow) { %i[step_one octo_name palp_pass palp_step step_two fail_two] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { true } }
              let(:param5) { -> { false } }
              let(:param6) { -> { false } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: true,
                    palp_fail: nil,
                    palp_pass: false,
                    step_two: false,
                    pass_one: nil,
                    fail_two: true,
                    error_handler_palp_step: nil,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end
          end

          context 'when palp_step failure' do
            let(:railway_flow) { %i[step_one octo_name palp_pass palp_step pass_one] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { false } }
            let(:param4) { -> { true } }
            let(:param5) { -> { false } }
            let(:param6) { -> { true } }
            let(:param7) { -> { true } }
            let(:param8) { -> { true } }
            let(:expected_state) do
              {
                action_status: :success,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  fail_one: nil,
                  palp_step: false,
                  palp_fail: nil,
                  palp_pass: false,
                  step_two: nil,
                  pass_one: true,
                  fail_two: nil,
                  error_handler_palp_step: nil,
                  error_handler_palp_fail: nil,
                  error_handler_palp_pass: nil
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when palp_step raises an error' do
            context 'when palp_fail success' do
              let(:railway_flow) do
                %i[
                  step_one
                  octo_name
                  palp_pass
                  palp_step
                  error_handler_palp_step
                  palp_fail
                  fail_two
                ]
              end
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { raise ArgumentError, step_error_message } }
              let(:param4) { -> { true } }
              let(:param5) { -> { false } }
              let(:param6) { -> { true } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: nil,
                    palp_fail: true,
                    palp_pass: false,
                    step_two: nil,
                    pass_one: nil,
                    fail_two: true,
                    error_handler_palp_step: step_error_message,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when palp_fail failure' do
              let(:railway_flow) do
                %i[
                  step_one
                  octo_name
                  palp_pass
                  palp_step
                  error_handler_palp_step
                  palp_fail
                  step_two
                  pass_one
                ]
              end
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { raise ArgumentError, step_error_message } }
              let(:param4) { -> { false } }
              let(:param5) { -> { false } }
              let(:param6) { -> { true } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :success,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: nil,
                    palp_fail: false,
                    palp_pass: false,
                    step_two: true,
                    pass_one: true,
                    fail_two: nil,
                    error_handler_palp_step: step_error_message,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end
          end
        end
      end

      context 'when octo_key octo_key3' do
        let(:octo_key) { :octo_key3 }

        context 'when palp_pass success' do
          context 'when palp_step success' do
            context 'when palp_fail success' do
              let(:railway_flow) { %i[step_one octo_name palp_pass palp_step palp_fail pass_one] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { true } }
              let(:param5) { -> { true } }
              let(:param6) { -> { true } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :success,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: true,
                    palp_fail: true,
                    palp_pass: true,
                    step_two: nil,
                    pass_one: true,
                    fail_two: nil,
                    error_handler_palp_step: nil,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when palp_fail failure' do
              context 'when step_two success' do
                let(:railway_flow) { %i[step_one octo_name palp_pass palp_step palp_fail palp_step step_two pass_one] }
                let(:param1) { -> { true } }
                let(:param2) { -> { true } }
                let(:param3) { -> { true } }
                let(:param4) { -> { false } }
                let(:param5) { -> { true } }
                let(:param6) { -> { true } }
                let(:param7) { -> { true } }
                let(:param8) { -> { true } }
                let(:expected_state) do
                  {
                    action_status: :success,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      step_one: true,
                      fail_one: nil,
                      palp_step: true,
                      palp_fail: false,
                      palp_pass: true,
                      step_two: true,
                      pass_one: true,
                      fail_two: nil,
                      error_handler_palp_step: nil,
                      error_handler_palp_fail: nil,
                      error_handler_palp_pass: nil
                    }
                  }
                end

                it_behaves_like 'check action state'
              end

              context 'when step_two failure' do
                let(:railway_flow) { %i[step_one octo_name palp_pass palp_step palp_fail palp_step step_two fail_two] }
                let(:param1) { -> { true } }
                let(:param2) { -> { true } }
                let(:param3) { -> { true } }
                let(:param4) { -> { false } }
                let(:param5) { -> { true } }
                let(:param6) { -> { false } }
                let(:param7) { -> { true } }
                let(:param8) { -> { true } }
                let(:expected_state) do
                  {
                    action_status: :failure,
                    railway_flow: railway_flow,
                    errors: {},
                    state: {
                      step_one: true,
                      fail_one: nil,
                      palp_step: true,
                      palp_fail: false,
                      palp_pass: true,
                      step_two: false,
                      pass_one: nil,
                      fail_two: true,
                      error_handler_palp_step: nil,
                      error_handler_palp_fail: nil,
                      error_handler_palp_pass: nil
                    }
                  }
                end

                it_behaves_like 'check action state'
              end
            end
          end

          context 'when palp_step failure' do
            context 'when step_two success' do
              let(:railway_flow) { %i[step_one octo_name palp_pass palp_step step_two pass_one] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { false } }
              let(:param4) { -> { true } }
              let(:param5) { -> { true } }
              let(:param6) { -> { true } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :success,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: false,
                    palp_fail: nil,
                    palp_pass: true,
                    step_two: true,
                    pass_one: true,
                    fail_two: nil,
                    error_handler_palp_step: nil,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when step_two failure' do
              let(:railway_flow) { %i[step_one octo_name palp_pass palp_step step_two fail_two] }
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { false } }
              let(:param4) { -> { true } }
              let(:param5) { -> { true } }
              let(:param6) { -> { false } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: false,
                    palp_fail: nil,
                    palp_pass: true,
                    step_two: false,
                    pass_one: nil,
                    fail_two: true,
                    error_handler_palp_step: nil,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: nil
                  }
                }
              end

              it_behaves_like 'check action state'
            end
          end
        end

        context 'when palp_pass raises an error' do
          context 'when palp_fail success' do
            let(:railway_flow) { %i[step_one octo_name palp_pass error_handler_palp_pass palp_fail pass_one] }
            let(:param1) { -> { true } }
            let(:param2) { -> { true } }
            let(:param3) { -> { true } }
            let(:param4) { -> { true } }
            let(:param5) { -> { raise ArgumentError, pass_error_message } }
            let(:param6) { -> { true } }
            let(:param7) { -> { true } }
            let(:param8) { -> { true } }
            let(:expected_state) do
              {
                action_status: :success,
                railway_flow: railway_flow,
                errors: {},
                state: {
                  step_one: true,
                  fail_one: nil,
                  palp_step: nil,
                  palp_fail: true,
                  palp_pass: nil,
                  step_two: nil,
                  pass_one: true,
                  fail_two: nil,
                  error_handler_palp_step: nil,
                  error_handler_palp_fail: nil,
                  error_handler_palp_pass: pass_error_message
                }
              }
            end

            it_behaves_like 'check action state'
          end

          context 'when palp_fail failure' do
            context 'when step_two success' do
              let(:railway_flow) do
                %i[
                  step_one
                  octo_name
                  palp_pass
                  error_handler_palp_pass
                  palp_fail
                  palp_step
                  step_two
                  pass_one
                ]
              end
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { false } }
              let(:param5) { -> { raise ArgumentError, pass_error_message } }
              let(:param6) { -> { true } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :success,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: true,
                    palp_fail: false,
                    palp_pass: nil,
                    step_two: true,
                    pass_one: true,
                    fail_two: nil,
                    error_handler_palp_step: nil,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: pass_error_message
                  }
                }
              end

              it_behaves_like 'check action state'
            end

            context 'when step_two failure' do
              let(:railway_flow) do
                %i[
                  step_one
                  octo_name
                  palp_pass
                  error_handler_palp_pass
                  palp_fail
                  palp_step
                  step_two
                  fail_two
                ]
              end
              let(:param1) { -> { true } }
              let(:param2) { -> { true } }
              let(:param3) { -> { true } }
              let(:param4) { -> { false } }
              let(:param5) { -> { raise ArgumentError, pass_error_message } }
              let(:param6) { -> { false } }
              let(:param7) { -> { true } }
              let(:param8) { -> { true } }
              let(:expected_state) do
                {
                  action_status: :failure,
                  railway_flow: railway_flow,
                  errors: {},
                  state: {
                    step_one: true,
                    fail_one: nil,
                    palp_step: true,
                    palp_fail: false,
                    palp_pass: nil,
                    step_two: false,
                    pass_one: nil,
                    fail_two: true,
                    error_handler_palp_step: nil,
                    error_handler_palp_fail: nil,
                    error_handler_palp_pass: pass_error_message
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
        context 'when fail_two success' do
          let(:railway_flow) { %i[step_one fail_one fail_two] }
          let(:param1) { -> { false } }
          let(:param2) { -> { true } }
          let(:param3) { -> { true } }
          let(:param4) { -> { true } }
          let(:param5) { -> { true } }
          let(:param6) { -> { true } }
          let(:param7) { -> { true } }
          let(:param8) { -> { true } }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: false,
                fail_one: true,
                palp_step: nil,
                palp_fail: nil,
                palp_pass: nil,
                step_two: nil,
                pass_one: nil,
                fail_two: true,
                error_handler_palp_step: nil,
                error_handler_palp_fail: nil,
                error_handler_palp_pass: nil
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
          let(:param5) { -> { true } }
          let(:param6) { -> { true } }
          let(:param7) { -> { true } }
          let(:param8) { -> { false } }
          let(:expected_state) do
            {
              action_status: :failure,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: false,
                fail_one: true,
                palp_step: nil,
                palp_fail: nil,
                palp_pass: nil,
                step_two: nil,
                pass_one: nil,
                fail_two: false,
                error_handler_palp_step: nil,
                error_handler_palp_fail: nil,
                error_handler_palp_pass: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end

      context 'when fail_one failure' do
        context 'when pass_one success' do
          let(:railway_flow) { %i[step_one fail_one pass_one] }
          let(:param1) { -> { false } }
          let(:param2) { -> { false } }
          let(:param3) { -> { true } }
          let(:param4) { -> { true } }
          let(:param5) { -> { true } }
          let(:param6) { -> { true } }
          let(:param7) { -> { true } }
          let(:param8) { -> { true } }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: false,
                fail_one: false,
                palp_step: nil,
                palp_fail: nil,
                palp_pass: nil,
                step_two: nil,
                pass_one: true,
                fail_two: nil,
                error_handler_palp_step: nil,
                error_handler_palp_fail: nil,
                error_handler_palp_pass: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end

        context 'when pass_one failure' do
          let(:railway_flow) { %i[step_one fail_one pass_one] }
          let(:param1) { -> { false } }
          let(:param2) { -> { false } }
          let(:param3) { -> { true } }
          let(:param4) { -> { true } }
          let(:param5) { -> { true } }
          let(:param6) { -> { true } }
          let(:param7) { -> { false } }
          let(:param8) { -> { true } }
          let(:expected_state) do
            {
              action_status: :success,
              railway_flow: railway_flow,
              errors: {},
              state: {
                step_one: false,
                fail_one: false,
                palp_step: nil,
                palp_fail: nil,
                palp_pass: nil,
                step_two: nil,
                pass_one: false,
                fail_two: nil,
                error_handler_palp_step: nil,
                error_handler_palp_fail: nil,
                error_handler_palp_pass: nil
              }
            }
          end

          it_behaves_like 'check action state'
        end
      end
    end
  end

  describe 'when octo block is not defined' do
    let(:action_block) { when_octo_block_is_not_defined }

    message = format(
      Decouplio::Const::Validations::Octo::OCTO_BLOCK
    )

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::OctoBlockIsNotDefinedError,
                    message: message
  end

  describe 'when octo block is empty' do
    let(:action_block) { when_octo_block_is_empty }

    message = format(
      Decouplio::Const::Validations::Octo::OCTO_BLOCK
    )

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::OctoBlockIsNotDefinedError,
                    message: message
  end
end
