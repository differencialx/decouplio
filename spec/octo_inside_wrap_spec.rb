# frozen_string_literal: true

RSpec.describe 'Octo inside wrap' do
  include_context 'with basic spec setup'

  let(:input_params) do
    {
      pl1: -> { pl1 },
      pl2: -> { pl2 },
      pl3: -> { pl3 },
      pl4: -> { pl4 },
      ws1: -> { ws1 },
      final: -> { final },
      octo_key: octo_key,
      process_step_three: process_step_three
    }
  end
  let(:pl1) { nil }
  let(:pl2) { nil }
  let(:pl3) { nil }
  let(:pl4) { nil }
  let(:ws1) { nil }
  let(:final) { nil }
  let(:octo_key) { nil }
  let(:process_step_three) { nil }

  context 'when on_success is not allowed' do
    let(:action_block) { when_octo_inside_wrap }

    context 'when octo1' do
      let(:octo_key) { :octo1 }

      context 'when success' do
        let(:pl1) { true }
        let(:pl4) { true }
        let(:ws1) { true }
        let(:final) { true }
        let(:railway_flow) do
          %i[
            wrap_for_octo
            strategy_one
            octo1
            step_one
            step_four
            wrap_step
            final_step
          ]
        end

        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: true,
              step_two: nil,
              step_three: nil,
              step_four: true,
              wrap_step: true,
              handle_resq: nil,
              final_step: true,
              strategy_failure: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when failure' do
        let(:pl1) { true }
        let(:process_step_three) { true }
        let(:pl3) { false }
        let(:railway_flow) do
          %i[
            wrap_for_octo
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
              step_one: true,
              step_two: nil,
              step_three: false,
              step_four: nil,
              wrap_step: nil,
              handle_resq: nil,
              final_step: nil,
              strategy_failure: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when error' do
        let(:error_message) { 'error message' }
        let(:pl1) { true }
        let(:process_step_three) { true }
        let(:pl3) { raise ArgumentError, error_message }
        let(:railway_flow) do
          %i[
            wrap_for_octo
            strategy_one
            octo1
            step_one
            step_three
            handle_resq
            strategy_failure
          ]
        end

        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: true,
              step_two: nil,
              step_three: nil,
              step_four: nil,
              wrap_step: nil,
              handle_resq: error_message,
              final_step: nil,
              strategy_failure: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when octo2' do
      let(:octo_key) { :octo2 }

      context 'when success' do
        let(:pl2) { true }
        let(:pl3) { true }
        let(:ws1) { true }
        let(:final) { true }
        let(:railway_flow) do
          %i[
            wrap_for_octo
            strategy_one
            octo2
            step_two
            step_three
            wrap_step
            final_step
          ]
        end

        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: nil,
              step_two: true,
              step_three: true,
              step_four: nil,
              wrap_step: true,
              handle_resq: nil,
              final_step: true,
              strategy_failure: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when failure' do
        let(:pl2) { true }
        let(:pl3) { false }
        let(:railway_flow) do
          %i[
            wrap_for_octo
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
              step_one: nil,
              step_two: true,
              step_three: false,
              step_four: nil,
              wrap_step: nil,
              handle_resq: nil,
              final_step: nil,
              strategy_failure: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when error' do
        let(:error_message) { 'error message' }
        let(:pl2) { true }
        let(:pl3) { raise ArgumentError, error_message }
        let(:railway_flow) do
          %i[
            wrap_for_octo
            strategy_one
            octo2
            step_two
            step_three
            handle_resq
            strategy_failure
          ]
        end

        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: nil,
              step_two: true,
              step_three: nil,
              step_four: nil,
              wrap_step: nil,
              handle_resq: error_message,
              final_step: nil,
              strategy_failure: 'Failure'
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end
  end
end
