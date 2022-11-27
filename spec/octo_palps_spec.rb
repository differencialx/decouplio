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
              octo1
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
              octo1
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
                octo1
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
                    octo1
                    step_one
                    step_four
                    strategy_two
                    octo4
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
                      octo1
                      step_one
                      step_three
                      step_four
                      strategy_two
                      octo4
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
                      octo1
                      step_one
                      step_three
                      step_four
                      strategy_two
                      octo4
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
                    octo1
                    step_one
                    step_four
                    strategy_two
                    octo5
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
                    octo1
                    step_one
                    step_four
                    strategy_two
                    octo5
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
                octo2
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
                octo2
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
              octo2
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
                octo2
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
                    octo2
                    step_two
                    step_three
                    strategy_two
                    octo4
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
                      octo2
                      step_two
                      step_three
                      strategy_two
                      octo4
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
                      octo2
                      step_two
                      step_three
                      strategy_two
                      octo4
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
                    octo2
                    step_two
                    step_three
                    strategy_two
                    octo5
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
                    octo2
                    step_two
                    step_three
                    strategy_two
                    octo5
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
                octo3
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
                octo3
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
                octo3
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
              octo3
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
                octo3
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
                    octo3
                    step_one
                    step_four
                    assign_second_strategy
                    strategy_two
                    octo4
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
                      octo3
                      step_one
                      step_four
                      assign_second_strategy
                      strategy_two
                      octo4
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
                      octo3
                      step_one
                      step_four
                      assign_second_strategy
                      strategy_two
                      octo4
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
                    octo3
                    step_one
                    step_four
                    assign_second_strategy
                    strategy_two
                    octo5
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
                    octo3
                    step_one
                    step_four
                    assign_second_strategy
                    strategy_two
                    octo5
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

  describe 'when octo finish him is not allowed' do
    let(:action_block) { when_octo_finish_him_not_allowed }

    message = format(
      Decouplio::Const::Validations::Octo::FINISH_HIM_IS_NOT_ALLOWED
    )

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::OctoFinishHimIsNotAllowedError,
                    message: message
  end

  describe 'when octo step finish him is not allowed' do
    let(:action_block) { when_octo_step_finish_him_is_not_allowed }

    message = format(
      Decouplio::Const::Validations::Octo::PALP_ON_ERROR_MESSAGE,
      '{:finish_him=>:on_error}',
      Decouplio::Const::Validations::Octo::ON_ALLOWED_OPTIONS,
      Decouplio::Const::Validations::Octo::MANUAL_URL
    )

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::OptionsValidationError,
                    message: message
  end
end
