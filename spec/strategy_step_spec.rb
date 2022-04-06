# frozen_string_literal: true

RSpec.describe 'Decouplio::Action strategy squad' do
  include_context 'with basic spec setup'

  describe '#call' do
    let(:input_params) do
      {
        strg_1: strg_1,
        strg_2: strg_2,
        param1: param1,
        param2: param2,
        param3: param3,
        param4: param4,
        param5: param5,
        final: final
      }
    end

    let(:strg_1) { nil }
    let(:strg_2) { nil }
    let(:param1) { 'param1' }
    let(:param2) { 'param2' }
    let(:param3) { 'param3' }
    let(:param4) { 'param4' }
    let(:param5) { 'param5' }
    let(:final) { 'Final' }

    describe 'on_success' do
      let(:action_block) { strategy_steps }

      context 'when strategy_one' do
        describe 'fails' do
          let(:strg_1) { :strg_1 }
          let(:param1) { false }
          let(:railway_flow) { %i[assign_strategy_one_key step_one strategy_failure] }

          it 'fails' do
            expect(action).to be_failure
            expect(action[:strategy_one_key]).to eq strg_1
            expect(action[:strategy_two_key]).to be_nil
            expect(action[:step_one]).to eq param1
            expect(action[:step_two]).to be_nil
            expect(action[:step_three]).to be_nil
            expect(action[:step_four]).to be_nil
            expect(action[:step_five]).to be_nil
            expect(action[:result]).to be_nil
            expect(action[:strategy_failure_handled]).to be true
            expect(action.railway_flow).to eq railway_flow
          end
        end

        describe 'pass' do
          context 'when strg_1 value' do
            let(:strg_1) { :strg_1 }

            context 'when strategy_two' do
              describe 'fails' do
                let(:strg_2) { :strg_4 }
                let(:param4) { false }
                let(:railway_flow) do
                  %i[assign_strategy_one_key step_one assign_strategy_two_key step_four strategy_failure]
                end

                it 'fails' do
                  expect(action).to be_failure
                  expect(action[:strategy_one_key]).to eq strg_1
                  expect(action[:strategy_two_key]).to eq strg_2
                  expect(action[:step_one]).to eq param1
                  expect(action[:step_two]).to be_nil
                  expect(action[:step_three]).to be_nil
                  expect(action[:step_four]).to eq param4
                  expect(action[:step_five]).to be_nil
                  expect(action[:result]).to be_nil
                  expect(action[:strategy_failure_handled]).to be true
                  expect(action.railway_flow).to eq railway_flow
                end
              end

              describe 'pass' do
                context 'when strg_4 value' do
                  let(:strg_2) { :strg_4 }
                  let(:railway_flow) do
                    %i[assign_strategy_one_key step_one assign_strategy_two_key step_four final_step]
                  end

                  it 'pass' do
                    expect(action).to be_success
                    expect(action[:strategy_one_key]).to eq strg_1
                    expect(action[:strategy_two_key]).to eq strg_2
                    expect(action[:step_one]).to eq param1
                    expect(action[:step_two]).to be_nil
                    expect(action[:step_three]).to be_nil
                    expect(action[:step_four]).to eq param4
                    expect(action[:step_five]).to be_nil
                    expect(action[:result]).to eq final
                    expect(action[:strategy_failure_handled]).to be_nil
                    expect(action.railway_flow).to eq railway_flow
                  end
                end

                context 'when strg_5 value' do
                  let(:strg_2) { :strg_5 }
                  let(:railway_flow) do
                    %i[assign_strategy_one_key step_one assign_strategy_two_key step_five final_step]
                  end

                  it 'pass' do
                    expect(action).to be_success
                    expect(action[:strategy_one_key]).to eq strg_1
                    expect(action[:strategy_two_key]).to eq strg_2
                    expect(action[:step_one]).to eq param1
                    expect(action[:step_two]).to be_nil
                    expect(action[:step_three]).to be_nil
                    expect(action[:step_four]).to be_nil
                    expect(action[:step_five]).to eq param5
                    expect(action[:result]).to eq final
                    expect(action[:strategy_failure_handled]).to be_nil
                    expect(action.railway_flow).to eq railway_flow
                  end
                end
              end
            end
          end

          context 'when strg_2 value' do
            let(:strg_1) { :strg_2 }

            context 'when strategy_two' do
              describe 'fails' do
                let(:strg_2) { :strg_4 }
                let(:param4) { false }
                let(:railway_flow) do
                  %i[assign_strategy_one_key step_two assign_strategy_two_key step_four strategy_failure]
                end

                it 'fails' do
                  expect(action).to be_failure
                  expect(action[:strategy_one_key]).to eq strg_1
                  expect(action[:strategy_two_key]).to eq strg_2
                  expect(action[:step_one]).to be_nil
                  expect(action[:step_two]).to eq param2
                  expect(action[:step_three]).to be_nil
                  expect(action[:step_four]).to eq param4
                  expect(action[:step_five]).to be_nil
                  expect(action[:result]).to be_nil
                  expect(action[:strategy_failure_handled]).to be true
                  expect(action.railway_flow).to eq railway_flow
                end
              end

              describe 'pass' do
                context 'when strg_4 value' do
                  let(:strg_2) { :strg_4 }
                  let(:railway_flow) do
                    %i[assign_strategy_one_key step_two assign_strategy_two_key step_four final_step]
                  end

                  it 'pass' do
                    expect(action).to be_success
                    expect(action[:strategy_one_key]).to eq strg_1
                    expect(action[:strategy_two_key]).to eq strg_2
                    expect(action[:step_one]).to be_nil
                    expect(action[:step_two]).to eq param2
                    expect(action[:step_three]).to be_nil
                    expect(action[:step_four]).to eq param4
                    expect(action[:step_five]).to be_nil
                    expect(action[:result]).to eq final
                    expect(action[:strategy_failure_handled]).to be_nil
                    expect(action.railway_flow).to eq railway_flow
                  end
                end

                context 'when strg_5 value' do
                  let(:strg_2) { :strg_5 }
                  let(:railway_flow) do
                    %i[assign_strategy_one_key step_two assign_strategy_two_key step_five final_step]
                  end

                  it 'pass' do
                    expect(action).to be_success
                    expect(action[:strategy_one_key]).to eq strg_1
                    expect(action[:strategy_two_key]).to eq strg_2
                    expect(action[:step_one]).to be_nil
                    expect(action[:step_two]).to eq param2
                    expect(action[:step_three]).to be_nil
                    expect(action[:step_four]).to be_nil
                    expect(action[:step_five]).to eq param5
                    expect(action[:result]).to eq final
                    expect(action[:strategy_failure_handled]).to be_nil
                    expect(action.railway_flow).to eq railway_flow
                  end
                end
              end
            end
          end

          context 'when strg_3 value' do
            let(:strg_1) { :strg_3 }

            context 'when strategy_two' do
              describe 'fails' do
                let(:strg_2) { :strg_4 }
                let(:param4) { false }
                let(:railway_flow) do
                  %i[assign_strategy_one_key step_three assign_strategy_two_key step_four strategy_failure]
                end

                it 'fails' do
                  expect(action).to be_failure
                  expect(action[:strategy_one_key]).to eq strg_1
                  expect(action[:strategy_two_key]).to eq strg_2
                  expect(action[:step_one]).to be_nil
                  expect(action[:step_two]).to be_nil
                  expect(action[:step_three]).to eq param3
                  expect(action[:step_four]).to eq param4
                  expect(action[:step_five]).to be_nil
                  expect(action[:result]).to be_nil
                  expect(action[:strategy_failure_handled]).to be true
                  expect(action.railway_flow).to eq railway_flow
                end
              end

              describe 'pass' do
                context 'when strg_4 value' do
                  let(:strg_2) { :strg_4 }
                  let(:railway_flow) do
                    %i[assign_strategy_one_key step_three assign_strategy_two_key step_four final_step]
                  end

                  it 'pass' do
                    expect(action).to be_success
                    expect(action[:strategy_one_key]).to eq strg_1
                    expect(action[:strategy_two_key]).to eq strg_2
                    expect(action[:step_one]).to be_nil
                    expect(action[:step_two]).to be_nil
                    expect(action[:step_three]).to eq param3
                    expect(action[:step_four]).to eq param4
                    expect(action[:step_five]).to be_nil
                    expect(action[:result]).to eq final
                    expect(action[:strategy_failure_handled]).to be_nil
                    expect(action.railway_flow).to eq railway_flow
                  end
                end

                context 'when strg_5 value' do
                  let(:strg_2) { :strg_5 }
                  let(:railway_flow) do
                    %i[assign_strategy_one_key step_three assign_strategy_two_key step_five final_step]
                  end

                  it 'pass' do
                    expect(action).to be_success
                    expect(action[:strategy_one_key]).to eq strg_1
                    expect(action[:strategy_two_key]).to eq strg_2
                    expect(action[:step_one]).to be_nil
                    expect(action[:step_two]).to be_nil
                    expect(action[:step_three]).to eq param3
                    expect(action[:step_four]).to be_nil
                    expect(action[:step_five]).to eq param5
                    expect(action[:result]).to eq final
                    expect(action[:strategy_failure_handled]).to be_nil
                    expect(action.railway_flow).to eq railway_flow
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
