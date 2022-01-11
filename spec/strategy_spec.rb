# frozen_string_literal: true

RSpec.describe 'Decouplio::Action strategy squad' do
  include_context 'with basic spec setup'

  describe '#call' do
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
    let(:param6) { 'param6' }
    let(:final) { 'Final' }
    let(:strategy_two_key) { 'not_existing_strategy' }
    let(:process_step_four) { true }
    let(:process_step_three) { true }

    describe 'on_success' do
      let(:action_block) { strategy_squads }

      context 'when strg_1' do
        context 'when strg_1 fails' do
          let(:strategy_one_key) { :strg_1 }
          let(:process_strategy_two) { false }
          let(:process_step_three) { true }
          let(:param3) { false }
          let(:railway_flow) do
            %i[
              assign_strategy_one_key
              step_one
              step_three
              strategy_failure
            ]
          end

          it 'sets params to ctx' do
            expect(action[:strg_key]).to eq strategy_one_key
            expect(action[:step_one]).to eq param1
            expect(action[:step_two]).to be_nil
            expect(action[:step_three]).to eq param3
            expect(action[:step_four]).to be_nil
            expect(action[:step_five]).to be_nil
            expect(action[:step_six]).to be_nil
            expect(action[:process_strategy_two]).to be false
            expect(action[:result]).to be_nil
            expect(action[:strategy_failure_handled]).to be true
          end

          it 'sets proper railway flow' do
            expect(action.railway_flow).to eq railway_flow
          end

          it 'success' do
            expect(action.failure?).to be true
          end
        end

        context 'when strg_1 passes and strategy two should not be processed' do
          let(:strategy_one_key) { :strg_1 }
          let(:process_strategy_two) { false }
          let(:process_step_three) { nil }
          let(:railway_flow) do
            %i[
              assign_strategy_one_key
              step_one
              step_four
              final_step
            ]
          end

          it 'sets params to ctx' do
            expect(action[:strg_key]).to eq strategy_one_key
            expect(action[:step_one]).to eq param1
            expect(action[:step_two]).to be_nil
            expect(action[:step_three]).to be_nil
            expect(action[:step_four]).to eq param4
            expect(action[:step_five]).to be_nil
            expect(action[:step_six]).to be_nil
            expect(action[:process_strategy_two]).to be false
            expect(action[:result]).to eq final
            expect(action[:strategy_failure_handled]).to be_nil
          end

          it 'sets proper railway flow' do
            expect(action.railway_flow).to eq railway_flow
          end

          it 'success' do
            expect(action.success?).to be true
          end
        end

        context 'when strategy two should be processed' do
          context 'when strg_1 fails' do
            let(:strategy_one_key) { :strg_1 }
            let(:strategy_two_key) { :strg_4 }
            let(:process_strategy_two) { true }
            let(:process_step_three) { true }
            let(:param3) { false }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                step_one
                step_three
                strategy_failure
              ]
            end

            it 'sets params to ctx' do
              expect(action[:strg_key]).to eq strategy_one_key
              expect(action[:step_one]).to eq param1
              expect(action[:step_two]).to be_nil
              expect(action[:step_three]).to eq param3
              expect(action[:step_four]).to be_nil
              expect(action[:step_five]).to be_nil
              expect(action[:step_six]).to be_nil
              expect(action[:process_strategy_two]).to be true
              expect(action[:result]).to be_nil
              expect(action[:strategy_failure_handled]).to be true
            end

            it 'sets proper railway flow' do
              expect(action.railway_flow).to eq railway_flow
            end

            it 'success' do
              expect(action.failure?).to be true
            end
          end

          context 'when strg_1 passes' do
            context 'when strg_4' do
              let(:strategy_one_key) { :strg_1 }
              let(:strategy_two_key) { :strg_4 }
              let(:process_strategy_two) { true }

              context 'when step_five passes' do
                let(:process_step_three) { nil }
                let(:process_step_four) { true }
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    step_one
                    step_four
                    step_five
                    final_step
                  ]
                end

                it 'sets params to ctx' do
                  expect(action[:strg_key]).to eq strategy_one_key
                  expect(action[:strategy_two_key]).to eq strategy_two_key
                  expect(action[:step_one]).to eq param1
                  expect(action[:step_two]).to be_nil
                  expect(action[:step_three]).to be_nil
                  expect(action[:step_four]).to eq param4
                  expect(action[:step_five]).to eq param5
                  expect(action[:step_six]).to be_nil
                  expect(action[:process_strategy_two]).to be true
                  expect(action[:result]).to eq final
                  expect(action[:strategy_failure_handled]).to be_nil
                end

                it 'sets proper railway flow' do
                  expect(action.railway_flow).to eq railway_flow
                end

                it 'success' do
                  expect(action.success?).to be true
                end
              end

              context 'when step_five fails' do
                context 'when step_four should be precessed' do
                  let(:param5) { false }
                  let(:process_step_three) { true }
                  let(:process_step_four) { true }
                  let(:railway_flow) do
                    %i[
                      assign_strategy_one_key
                      step_one
                      step_three
                      step_four
                      step_five
                      step_four
                      strategy_failure
                    ]
                  end

                  it 'sets params to ctx' do
                    expect(action[:strg_key]).to eq strategy_one_key
                    expect(action[:strategy_two_key]).to eq strategy_two_key
                    expect(action[:step_one]).to eq param1
                    expect(action[:step_two]).to be_nil
                    expect(action[:step_three]).to eq param3
                    expect(action[:step_four]).to eq(param4 + param4)
                    expect(action[:step_five]).to eq param5
                    expect(action[:step_six]).to be_nil
                    expect(action[:process_strategy_two]).to be true
                    expect(action[:result]).to be_nil
                    expect(action[:strategy_failure_handled]).to be true
                  end

                  it 'sets proper railway flow' do
                    expect(action.railway_flow).to eq railway_flow
                  end

                  it 'success' do
                    expect(action.failure?).to be true
                  end
                end

                context 'when step_four should not be processed' do
                  let(:param5) { false }
                  let(:process_step_three) { true }
                  let(:process_step_four) { false }
                  let(:railway_flow) do
                    %i[
                      assign_strategy_one_key
                      step_one
                      step_three
                      step_four
                      step_five
                      strategy_failure
                    ]
                  end

                  it 'sets params to ctx' do
                    expect(action[:strg_key]).to eq strategy_one_key
                    expect(action[:strategy_two_key]).to eq strategy_two_key
                    expect(action[:step_one]).to eq param1
                    expect(action[:step_two]).to be_nil
                    expect(action[:step_three]).to eq param3
                    expect(action[:step_four]).to eq param4
                    expect(action[:step_five]).to eq param5
                    expect(action[:step_six]).to be_nil
                    expect(action[:process_strategy_two]).to be true
                    expect(action[:result]).to be_nil
                    expect(action[:strategy_failure_handled]).to be true
                  end

                  it 'sets proper railway flow' do
                    expect(action.railway_flow).to eq railway_flow
                  end

                  it 'success' do
                    expect(action.failure?).to be true
                  end
                end
              end
            end

            context 'when strg_5' do
              let(:strategy_one_key) { :strg_1 }
              let(:strategy_two_key) { :strg_5 }
              let(:process_strategy_two) { true }

              context 'when step five fails' do
                let(:process_step_three) { nil }
                let(:param5) { nil }
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    step_one
                    step_four
                    step_five
                    step_six
                    strategy_failure
                  ]
                end

                it 'sets params to ctx' do
                  expect(action[:strg_key]).to eq strategy_one_key
                  expect(action[:strategy_two_key]).to eq strategy_two_key
                  expect(action[:step_one]).to eq param1
                  expect(action[:step_two]).to be_nil
                  expect(action[:step_three]).to be_nil
                  expect(action[:step_four]).to eq param4
                  expect(action[:step_five]).to eq param5
                  expect(action[:step_six]).to eq param6
                  expect(action[:process_strategy_two]).to be true
                  expect(action[:result]).to be_nil
                  expect(action[:strategy_failure_handled]).to be true
                end

                it 'sets proper railway flow' do
                  expect(action.railway_flow).to eq railway_flow
                end

                it 'success' do
                  expect(action.failure?).to be true
                end
              end

              context 'when step five pass' do
                let(:process_step_three) { nil }
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    step_one
                    step_four
                    step_five
                    step_four
                    final_step
                  ]
                end

                it 'sets params to ctx' do
                  expect(action[:strg_key]).to eq strategy_one_key
                  expect(action[:strategy_two_key]).to eq strategy_two_key
                  expect(action[:step_one]).to eq param1
                  expect(action[:step_two]).to be_nil
                  expect(action[:step_three]).to be_nil
                  expect(action[:step_four]).to eq param4 * 2
                  expect(action[:step_five]).to eq param5
                  expect(action[:step_six]).to be_nil
                  expect(action[:process_strategy_two]).to be true
                  expect(action[:result]).to eq final
                  expect(action[:strategy_failure_handled]).to be_nil
                end

                it 'sets proper railway flow' do
                  expect(action.railway_flow).to eq railway_flow
                end

                it 'success' do
                  expect(action.success?).to be true
                end
              end
            end
          end
        end
      end

      context 'when strg_2' do
        context 'when strg_2 fails' do
          let(:strategy_one_key) { :strg_2 }

          context 'when step_two fails' do
            let(:process_strategy_two) { false }
            let(:param2) { nil }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                step_two
                strategy_failure
              ]
            end

            it 'sets params to ctx' do
              expect(action[:strg_key]).to eq strategy_one_key
              expect(action[:strategy_two_key]).to eq 'not_existing_strategy'
              expect(action[:step_one]).to be_nil
              expect(action[:step_two]).to be_nil
              expect(action[:step_three]).to be_nil
              expect(action[:step_four]).to be_nil
              expect(action[:step_five]).to be_nil
              expect(action[:step_six]).to be_nil
              expect(action[:process_strategy_two]).to be false
              expect(action[:result]).to be_nil
              expect(action[:strategy_failure_handled]).to be true
            end

            it 'sets proper railway flow' do
              expect(action.railway_flow).to eq railway_flow
            end

            it 'success' do
              expect(action.failure?).to be true
            end
          end

          context 'when step_three fails' do
            let(:process_strategy_two) { false }
            let(:param3) { nil }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                step_two
                step_three
                strategy_failure
              ]
            end

            it 'sets params to ctx' do
              expect(action[:strg_key]).to eq strategy_one_key
              expect(action[:strategy_two_key]).to eq 'not_existing_strategy'
              expect(action[:step_one]).to be_nil
              expect(action[:step_two]).to eq param2
              expect(action[:step_three]).to be_nil
              expect(action[:step_four]).to be_nil
              expect(action[:step_five]).to be_nil
              expect(action[:step_six]).to be_nil
              expect(action[:process_strategy_two]).to be false
              expect(action[:result]).to be_nil
              expect(action[:strategy_failure_handled]).to be true
            end

            it 'sets proper railway flow' do
              expect(action.railway_flow).to eq railway_flow
            end

            it 'success' do
              expect(action.failure?).to be true
            end
          end
        end

        context 'when strg_2 passes' do
          let(:strategy_one_key) { :strg_2 }
          let(:process_strategy_two) { false }
          let(:railway_flow) do
            %i[
              assign_strategy_one_key
              step_two
              step_three
              final_step
            ]
          end

          it 'sets params to ctx' do
            expect(action[:strg_key]).to eq strategy_one_key
            expect(action[:step_one]).to be_nil
            expect(action[:step_two]).to eq param2
            expect(action[:step_three]).to eq param3
            expect(action[:step_four]).to be_nil
            expect(action[:step_five]).to be_nil
            expect(action[:step_six]).to be_nil
            expect(action[:process_strategy_two]).to be false
            expect(action[:result]).to eq final
            expect(action[:strategy_failure_handled]).to be_nil
          end

          it 'sets proper railway flow' do
            expect(action.railway_flow).to eq railway_flow
          end

          it 'success' do
            expect(action.success?).to be true
          end
        end

        context 'when strategy two should be processed' do
          context 'when strg_2 fails' do
            let(:strategy_one_key) { :strg_2 }
            let(:strategy_two_key) { :strg_4 }
            let(:process_strategy_two) { true }
            let(:process_step_three) { true }
            let(:param3) { nil }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                step_two
                step_three
                strategy_failure
              ]
            end

            it 'sets params to ctx' do
              expect(action[:strg_key]).to eq strategy_one_key
              expect(action[:step_one]).to be_nil
              expect(action[:step_two]).to eq param2
              expect(action[:step_three]).to be_nil
              expect(action[:step_four]).to be_nil
              expect(action[:step_five]).to be_nil
              expect(action[:step_six]).to be_nil
              expect(action[:process_strategy_two]).to be true
              expect(action[:result]).to be_nil
              expect(action[:strategy_failure_handled]).to be true
            end

            it 'sets proper railway flow' do
              expect(action.railway_flow).to eq railway_flow
            end

            it 'success' do
              expect(action.failure?).to be true
            end
          end

          context 'when strg_2 passes' do
            context 'when strg_4' do
              let(:strategy_one_key) { :strg_2 }
              let(:strategy_two_key) { :strg_4 }
              let(:process_strategy_two) { true }

              context 'when step_five passes' do
                let(:process_step_four) { true }
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    step_two
                    step_three
                    step_five
                    final_step
                  ]
                end

                it 'sets params to ctx' do
                  expect(action[:strg_key]).to eq strategy_one_key
                  expect(action[:strategy_two_key]).to eq strategy_two_key
                  expect(action[:step_one]).to be_nil
                  expect(action[:step_two]).to eq param2
                  expect(action[:step_three]).to eq param3
                  expect(action[:step_four]).to be_nil
                  expect(action[:step_five]).to eq param5
                  expect(action[:step_six]).to be_nil
                  expect(action[:process_strategy_two]).to be true
                  expect(action[:result]).to eq final
                  expect(action[:strategy_failure_handled]).to be_nil
                end

                it 'sets proper railway flow' do
                  expect(action.railway_flow).to eq railway_flow
                end

                it 'success' do
                  expect(action.success?).to be true
                end
              end

              context 'when step_five fails' do
                context 'when step_four should be precessed' do
                  let(:param5) { nil }
                  let(:process_step_three) { true }
                  let(:process_step_four) { true }
                  let(:railway_flow) do
                    %i[
                      assign_strategy_one_key
                      step_two
                      step_three
                      step_five
                      step_four
                      strategy_failure
                    ]
                  end

                  it 'sets params to ctx' do
                    expect(action[:strg_key]).to eq strategy_one_key
                    expect(action[:strategy_two_key]).to eq strategy_two_key
                    expect(action[:step_one]).to be_nil
                    expect(action[:step_two]).to eq param2
                    expect(action[:step_three]).to eq param3
                    expect(action[:step_four]).to eq param4
                    expect(action[:step_five]).to be_nil
                    expect(action[:step_six]).to be_nil
                    expect(action[:process_strategy_two]).to be true
                    expect(action[:result]).to be_nil
                    expect(action[:strategy_failure_handled]).to be true
                  end

                  it 'sets proper railway flow' do
                    expect(action.railway_flow).to eq railway_flow
                  end

                  it 'success' do
                    expect(action.failure?).to be true
                  end
                end

                context 'when step_four should not be processed' do
                  let(:param5) { nil }
                  let(:process_step_four) { false }
                  let(:railway_flow) do
                    %i[
                      assign_strategy_one_key
                      step_two
                      step_three
                      step_five
                      strategy_failure
                    ]
                  end

                  it 'sets params to ctx' do
                    expect(action[:strg_key]).to eq strategy_one_key
                    expect(action[:strategy_two_key]).to eq strategy_two_key
                    expect(action[:step_one]).to be_nil
                    expect(action[:step_two]).to eq param2
                    expect(action[:step_three]).to eq param3
                    expect(action[:step_four]).to be_nil
                    expect(action[:step_five]).to be_nil
                    expect(action[:step_six]).to be_nil
                    expect(action[:process_strategy_two]).to be true
                    expect(action[:result]).to be_nil
                    expect(action[:strategy_failure_handled]).to be true
                  end

                  it 'sets proper railway flow' do
                    expect(action.railway_flow).to eq railway_flow
                  end

                  it 'success' do
                    expect(action.failure?).to be true
                  end
                end
              end
            end

            context 'when strg_5' do
              let(:strategy_one_key) { :strg_2 }
              let(:strategy_two_key) { :strg_5 }
              let(:process_strategy_two) { true }

              context 'when step five fails' do
                let(:param5) { nil }
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    step_two
                    step_three
                    step_five
                    step_six
                    strategy_failure
                  ]
                end

                it 'sets params to ctx' do
                  expect(action[:strg_key]).to eq strategy_one_key
                  expect(action[:strategy_two_key]).to eq strategy_two_key
                  expect(action[:step_one]).to be_nil
                  expect(action[:step_two]).to eq param2
                  expect(action[:step_three]).to eq param3
                  expect(action[:step_four]).to be_nil
                  expect(action[:step_five]).to eq param5
                  expect(action[:step_six]).to eq param6
                  expect(action[:process_strategy_two]).to be true
                  expect(action[:result]).to be_nil
                  expect(action[:strategy_failure_handled]).to be true
                end

                it 'sets proper railway flow' do
                  expect(action.railway_flow).to eq railway_flow
                end

                it 'success' do
                  expect(action.failure?).to be true
                end
              end

              context 'when step five pass' do
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    step_two
                    step_three
                    step_five
                    step_four
                    final_step
                  ]
                end

                it 'sets params to ctx' do
                  expect(action[:strg_key]).to eq strategy_one_key
                  expect(action[:strategy_two_key]).to eq strategy_two_key
                  expect(action[:step_one]).to be_nil
                  expect(action[:step_two]).to eq param2
                  expect(action[:step_three]).to eq param3
                  expect(action[:step_four]).to eq param4
                  expect(action[:step_five]).to eq param5
                  expect(action[:step_six]).to be_nil
                  expect(action[:process_strategy_two]).to be true
                  expect(action[:result]).to eq final
                  expect(action[:strategy_failure_handled]).to be_nil
                end

                it 'sets proper railway flow' do
                  expect(action.railway_flow).to eq railway_flow
                end

                it 'success' do
                  expect(action.success?).to be true
                end
              end
            end
          end
        end
      end

      context 'when strg_3' do
        context 'when strg_3 fails' do
          let(:strategy_one_key) { :strg_3 }

          context 'when step_one fails' do
            let(:process_strategy_two) { false }
            let(:param1) { nil }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                step_one
                strategy_failure
              ]
            end

            it 'sets params to ctx' do
              expect(action[:strg_key]).to eq strategy_one_key
              expect(action[:strategy_two_key]).to eq 'not_existing_strategy'
              expect(action[:step_one]).to be_nil
              expect(action[:step_two]).to be_nil
              expect(action[:step_three]).to be_nil
              expect(action[:step_four]).to be_nil
              expect(action[:step_five]).to be_nil
              expect(action[:step_six]).to be_nil
              expect(action[:process_strategy_two]).to be false
              expect(action[:result]).to be_nil
              expect(action[:strategy_failure_handled]).to be true
            end

            it 'sets proper railway flow' do
              expect(action.railway_flow).to eq railway_flow
            end

            it 'success' do
              expect(action.failure?).to be true
            end
          end

          context 'when step_four fails' do
            let(:process_strategy_two) { false }
            let(:param4) { nil }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                step_one
                step_four
                strategy_failure
              ]
            end

            it 'sets params to ctx' do
              expect(action[:strg_key]).to eq strategy_one_key
              expect(action[:strategy_two_key]).to eq 'not_existing_strategy'
              expect(action[:step_one]).to eq param1
              expect(action[:step_two]).to be_nil
              expect(action[:step_three]).to be_nil
              expect(action[:step_four]).to be_nil
              expect(action[:step_five]).to be_nil
              expect(action[:step_six]).to be_nil
              expect(action[:process_strategy_two]).to be false
              expect(action[:result]).to be_nil
              expect(action[:strategy_failure_handled]).to be true
            end

            it 'sets proper railway flow' do
              expect(action.railway_flow).to eq railway_flow
            end

            it 'success' do
              expect(action.failure?).to be true
            end
          end

          context 'when assign_second_strategy fails' do
            let(:strategy_two_key) { nil }
            let(:process_strategy_two) { false }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                step_one
                step_four
                assign_second_strategy
                strategy_failure
              ]
            end

            it 'sets params to ctx' do
              expect(action[:strg_key]).to eq strategy_one_key
              expect(action[:strategy_two_key]).to be_nil
              expect(action[:step_one]).to eq param1
              expect(action[:step_two]).to be_nil
              expect(action[:step_three]).to be_nil
              expect(action[:step_four]).to eq param4
              expect(action[:step_five]).to be_nil
              expect(action[:step_six]).to be_nil
              expect(action[:process_strategy_two]).to be false
              expect(action[:result]).to be_nil
              expect(action[:strategy_failure_handled]).to be true
            end

            it 'sets proper railway flow' do
              expect(action.railway_flow).to eq railway_flow
            end

            it 'success' do
              expect(action.failure?).to be true
            end
          end
        end

        context 'when strg_3 passes' do
          let(:strategy_one_key) { :strg_3 }
          let(:strategy_two_key) { :strg_4 }
          let(:process_strategy_two) { false }
          let(:railway_flow) do
            %i[
              assign_strategy_one_key
              step_one
              step_four
              assign_second_strategy
              final_step
            ]
          end

          it 'sets params to ctx' do
            expect(action[:strg_key]).to eq strategy_one_key
            expect(action[:strategy_two_key]).to eq :strg_4
            expect(action[:step_one]).to eq param1
            expect(action[:step_two]).to be_nil
            expect(action[:step_three]).to be_nil
            expect(action[:step_four]).to eq param4
            expect(action[:step_five]).to be_nil
            expect(action[:step_six]).to be_nil
            expect(action[:process_strategy_two]).to be false
            expect(action[:result]).to eq final
            expect(action[:strategy_failure_handled]).to be_nil
          end

          it 'sets proper railway flow' do
            expect(action.railway_flow).to eq railway_flow
          end

          it 'success' do
            expect(action.success?).to be true
          end
        end

        context 'when strategy two should be processed' do
          context 'when strg_3 fails' do
            let(:strategy_one_key) { :strg_3 }
            let(:strategy_two_key) { :strg_4 }
            let(:process_strategy_two) { true }
            let(:process_step_three) { true }
            let(:param4) { nil }
            let(:railway_flow) do
              %i[
                assign_strategy_one_key
                step_one
                step_four
                strategy_failure
              ]
            end

            it 'sets params to ctx' do
              expect(action[:strg_key]).to eq strategy_one_key
              expect(action[:strategy_two_key]).to eq :strg_4
              expect(action[:step_one]).to eq param1
              expect(action[:step_two]).to be_nil
              expect(action[:step_three]).to be_nil
              expect(action[:step_four]).to be_nil
              expect(action[:step_five]).to be_nil
              expect(action[:step_six]).to be_nil
              expect(action[:process_strategy_two]).to be true
              expect(action[:result]).to be_nil
              expect(action[:strategy_failure_handled]).to be true
            end

            it 'sets proper railway flow' do
              expect(action.railway_flow).to eq railway_flow
            end

            it 'success' do
              expect(action.failure?).to be true
            end
          end

          context 'when strg_3 passes' do
            context 'when strg_4' do
              let(:strategy_one_key) { :strg_3 }
              let(:strategy_two_key) { :strg_4 }
              let(:process_strategy_two) { true }

              context 'when step_five passes' do
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    step_one
                    step_four
                    assign_second_strategy
                    step_five
                    final_step
                  ]
                end

                it 'sets params to ctx' do
                  expect(action[:strg_key]).to eq strategy_one_key
                  expect(action[:strategy_two_key]).to eq :strg_4
                  expect(action[:step_one]).to eq param1
                  expect(action[:step_two]).to be_nil
                  expect(action[:step_three]).to be_nil
                  expect(action[:step_four]).to eq param4
                  expect(action[:step_five]).to eq param5
                  expect(action[:step_six]).to be_nil
                  expect(action[:process_strategy_two]).to be true
                  expect(action[:result]).to eq final
                  expect(action[:strategy_failure_handled]).to be_nil
                end

                it 'sets proper railway flow' do
                  expect(action.railway_flow).to eq railway_flow
                end

                it 'success' do
                  expect(action.success?).to be true
                end
              end

              context 'when step_five fails' do
                context 'when step_four should be precessed' do
                  let(:param5) { nil }
                  let(:process_step_four) { true }
                  let(:railway_flow) do
                    %i[
                      assign_strategy_one_key
                      step_one
                      step_four
                      assign_second_strategy
                      step_five
                      step_four
                      strategy_failure
                    ]
                  end

                  it 'sets params to ctx' do
                    expect(action[:strg_key]).to eq strategy_one_key
                    expect(action[:strategy_two_key]).to eq strategy_two_key
                    expect(action[:step_one]).to eq param1
                    expect(action[:step_two]).to be_nil
                    expect(action[:step_three]).to be_nil
                    expect(action[:step_four]).to eq param4 * 2
                    expect(action[:step_five]).to eq param5
                    expect(action[:step_six]).to be_nil
                    expect(action[:process_strategy_two]).to be true
                    expect(action[:result]).to be_nil
                    expect(action[:strategy_failure_handled]).to be true
                  end

                  it 'sets proper railway flow' do
                    expect(action.railway_flow).to eq railway_flow
                  end

                  it 'success' do
                    expect(action.failure?).to be true
                  end
                end

                context 'when step_four should not be processed' do
                  let(:param5) { nil }
                  let(:process_step_four) { false }
                  let(:railway_flow) do
                    %i[
                      assign_strategy_one_key
                      step_one
                      step_four
                      assign_second_strategy
                      step_five
                      strategy_failure
                    ]
                  end

                  it 'sets params to ctx' do
                    expect(action[:strg_key]).to eq strategy_one_key
                    expect(action[:strategy_two_key]).to eq strategy_two_key
                    expect(action[:step_one]).to eq param1
                    expect(action[:step_two]).to be_nil
                    expect(action[:step_three]).to be_nil
                    expect(action[:step_four]).to eq param4
                    expect(action[:step_five]).to be_nil
                    expect(action[:step_six]).to be_nil
                    expect(action[:process_strategy_two]).to be true
                    expect(action[:result]).to be_nil
                    expect(action[:strategy_failure_handled]).to be true
                  end

                  it 'sets proper railway flow' do
                    expect(action.railway_flow).to eq railway_flow
                  end

                  it 'success' do
                    expect(action.failure?).to be true
                  end
                end
              end
            end

            context 'when strg_5' do
              let(:strategy_one_key) { :strg_3 }
              let(:strategy_two_key) { :strg_5 }
              let(:process_strategy_two) { true }

              context 'when step five fails' do
                let(:param5) { nil }
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    step_one
                    step_four
                    assign_second_strategy
                    step_five
                    step_six
                    strategy_failure
                  ]
                end

                it 'sets params to ctx' do
                  expect(action[:strg_key]).to eq strategy_one_key
                  expect(action[:strategy_two_key]).to eq strategy_two_key
                  expect(action[:step_one]).to eq param1
                  expect(action[:step_two]).to be_nil
                  expect(action[:step_three]).to be_nil
                  expect(action[:step_four]).to eq param4
                  expect(action[:step_five]).to eq param5
                  expect(action[:step_six]).to eq param6
                  expect(action[:process_strategy_two]).to be true
                  expect(action[:result]).to be_nil
                  expect(action[:strategy_failure_handled]).to be true
                end

                it 'sets proper railway flow' do
                  expect(action.railway_flow).to eq railway_flow
                end

                it 'success' do
                  expect(action.failure?).to be true
                end
              end

              context 'when step five pass' do
                let(:railway_flow) do
                  %i[
                    assign_strategy_one_key
                    step_one
                    step_four
                    assign_second_strategy
                    step_five
                    step_four
                    final_step
                  ]
                end

                it 'sets params to ctx' do
                  expect(action[:strg_key]).to eq strategy_one_key
                  expect(action[:strategy_two_key]).to eq strategy_two_key
                  expect(action[:step_one]).to eq param1
                  expect(action[:step_two]).to be_nil
                  expect(action[:step_three]).to be_nil
                  expect(action[:step_four]).to eq param4 * 2
                  expect(action[:step_five]).to eq param5
                  expect(action[:step_six]).to be_nil
                  expect(action[:process_strategy_two]).to be true
                  expect(action[:result]).to eq final
                  expect(action[:strategy_failure_handled]).to be_nil
                end

                it 'sets proper railway flow' do
                  expect(action.railway_flow).to eq railway_flow
                end

                it 'success' do
                  expect(action.success?).to be true
                end
              end
            end
          end
        end
      end
    end
  end
end
