# frozen_string_literal: true

RSpec.describe 'Decouplio::Action finish_him' do
  include_context 'with basic spec setup'

  describe '#call' do
    let(:input_params) do
      { param1: param1, param2: param2 }
    end
    let(:param1) { 'param1' }
    let(:param2) { nil }

    describe 'when finish_him on_success' do
      let(:action_block) { when_finish_him_on_success }
      let(:railway_flow) { %i[step_one step_two] }
      let(:param2) { true }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            result: param1
          }
        }
      end

      it_behaves_like 'check action state'
    end

    describe 'when finish_him on_failure' do
      let(:action_block) { when_finish_him_on_failure }
      let(:railway_flow) { %i[step_one step_two] }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            result: param1
          }
        }
      end

      it_behaves_like 'check action state'
    end

    describe 'when finish_him true for fail' do
      let(:action_block) { when_finish_him_true_for_fail }
      let(:railway_flow) { %i[step_one step_two] }
      let(:param1) { false }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            result: param1,
            step_two: param2
          }
        }
      end

      it_behaves_like 'check action state'
    end

    describe 'when finish_him true for pass' do
      let(:action_block) { when_finish_him_true_for_pass }
      let(:railway_flow) { %i[step_one step_two] }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            result: param1,
            step_two: param2
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end
end
