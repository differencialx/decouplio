# frozen_string_literal: true

RSpec.describe 'Decouplio::Action on_success on_failure' do
  include_context 'with basic spec setup'

  describe '#call' do
    let(:input_params) do
      {
        strategy_key: strategy_key,
        param1: param1,
        param2: param2,
        param3: param3,
        param4: param4
      }
    end

    let(:param1) { 'param1' }
    let(:param1) { 'param2' }
    let(:param1) { 'param3' }
    let(:param1) { 'param4' }

    describe 'on_success' do
      let(:action_block) { strategy_squads }
      
      context 'when strg_1' do
        let(:railway_flow) { %i[] }
      end
    end
  end
end