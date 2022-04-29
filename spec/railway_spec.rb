# frozen_string_literal: true

RSpec.describe 'Decouplio::Action railway specs' do
  include_context 'with basic spec setup'

  describe '#call' do
    let(:input_params) do
      { param1: param1, param2: param2 }
    end
    let(:param1) { 'param1' }
    let(:param2) { 'param2' }

    describe 'success_way' do
      let(:action_block) { success_way }

      context 'when success' do
        let(:railway_flow) { %i[model assign_result] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: param2
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when failure' do
        let(:railway_flow) { %i[model assign_result] }
        let(:param2) { false }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              model: param1,
              result: param2
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    describe 'failure_way' do
      let(:action_block) { failure_way }
      let(:railway_flow) { %i[model error] }
      let(:param1) { nil }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            result: nil,
            error: error_message
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    describe 'multiple_failure_way' do
      let(:action_block) { multiple_failure_way }
      let(:railway_flow) { %i[model fail_one fail_two fail_three] }
      let(:param1) { nil }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            result: nil,
            error1: 'Error message 1',
            error2: 'Error message 2',
            error3: 'Error message 3'
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    describe 'failure_with_finish_him' do
      let(:action_block) { failure_with_finish_him }
      let(:railway_flow) { %i[model fail_one fail_two] }
      let(:param1) { nil }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          state: {
            result: nil,
            error1: 'Error message 1',
            error2: 'Error message 2',
            error3: nil
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    describe 'conditional_execution_for_step' do
      let(:action_block) { conditional_execution_for_step }
      let(:param1) { 'param1' }

      context 'when assign result should be performed' do
        let(:param2) { true }
        let(:railway_flow) { %i[model assign_result final_step] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              final_step: param1,
              result: param1
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when assign result should not be performed' do
        let(:param2) { false }
        let(:railway_flow) { %i[model final_step] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              final_step: param1,
              result: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    describe 'conditional_execution_for_fail' do
      let(:action_block) { conditional_execution_for_fail }
      let(:param1) { nil }

      context 'when fail_one should be performed' do
        let(:param2) { true }
        let(:railway_flow) { %i[model fail_one fail_two] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              error1: 'Error message 1',
              error2: 'Error message 2',
              result: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when fail_one should not be performed' do
        let(:param2) { false }
        let(:railway_flow) { %i[model fail_two] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            state: {
              error1: nil,
              error2: 'Error message 2',
              result: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    describe 'pass_way' do
      let(:action_block) { pass_way }
      let(:railway_flow) { %i[model pass_step assign_result] }
      let(:param2) { false }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            result: param1,
            pass_step: param2
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end

    describe 'conditional pass_way' do
      let(:action_block) { conditional_execution_for_pass }

      context 'when param2 present' do
        let(:railway_flow) { %i[model pass_step assign_result] }
        let(:param2) { 'params2' }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: param1,
              pass_step: param2
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when param2 nil' do
        let(:param2) { nil }
        let(:railway_flow) { %i[model assign_result] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            state: {
              result: param1,
              pass_step: nil
            },
            errors: {}
          }
        end

        it_behaves_like 'check action state'
      end
    end

    describe 'same_step_several_times' do
      let(:action_block) { same_step_several_times }
      let(:param2) { 1 }
      let(:param1) { 1 }
      let(:railway_flow) do
        %i[increment increment increment increment]
      end
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          state: {
            param2: 5
          },
          errors: {}
        }
      end

      it_behaves_like 'check action state'
    end
  end
end
