# frozen_string_literal: true

RSpec.describe 'octo as step cases' do
  include_context 'with basic spec setup'

  let(:input_params) do
    {
      octo_key: octo_key,
      s1: -> { s1 },
      s2: -> { s2 },
      some_action_step: -> { some_action_step },
      some_service_step: -> { some_service_step }
    }
  end
  let(:octo_key) { nil }
  let(:s1) { nil }
  let(:some_action_step) { nil }
  let(:some_service_step) { nil }
  let(:action_block) { when_octo_as_step }

  context 'when octo1' do
    let(:octo_key) { :octo1 }

    context 'when success' do
      let(:s1) { true }
      let(:railway_flow) do
        %i[
          octo_name
          octo1
          step_one
          final
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
            some_action: nil,
            some_service: nil,
            final: 'Success',
            fail_final: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when failure' do
      let(:s1) { false }
      let(:railway_flow) do
        %i[
          octo_name
          octo1
          step_one
          fail_final
        ]
      end

      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: false,
            step_two: nil,
            some_action: nil,
            some_service: nil,
            final: nil,
            fail_final: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when octo2' do
    let(:octo_key) { :octo2 }

    context 'when success' do
      let(:some_action_step) { true }
      let(:railway_flow) do
        %i[
          octo_name
          octo2
          OctoAsStepCases::SomeAction
          some_action_step
          final
        ]
      end

      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: nil,
            step_two: nil,
            some_action: true,
            some_service: nil,
            final: 'Success',
            fail_final: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when failure' do
      let(:some_action_step) { false }
      let(:railway_flow) do
        %i[
          octo_name
          octo2
          OctoAsStepCases::SomeAction
          some_action_step
          fail_final
        ]
      end

      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: nil,
            step_two: nil,
            some_action: false,
            some_service: nil,
            final: nil,
            fail_final: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when octo3' do
    let(:octo_key) { :octo3 }

    context 'when success' do
      let(:some_service_step) { true }
      let(:railway_flow) do
        %i[
          octo_name
          octo3
          OctoAsStepCases::SomeService
          final
        ]
      end

      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: nil,
            step_two: nil,
            some_action: nil,
            some_service: true,
            final: 'Success',
            fail_final: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when failure' do
      let(:some_service_step) { false }
      let(:railway_flow) do
        %i[
          octo_name
          octo3
          OctoAsStepCases::SomeService
          fail_final
        ]
      end

      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: nil,
            step_two: nil,
            some_action: nil,
            some_service: false,
            final: nil,
            fail_final: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when octo4' do
    let(:octo_key) { :octo4 }

    context 'when success' do
      let(:s2) { true }
      let(:railway_flow) do
        %i[
          octo_name
          octo4
          step_two
          final
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
            some_action: nil,
            some_service: nil,
            final: 'Success',
            fail_final: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when failure' do
      let(:s2) { false }
      let(:railway_flow) do
        %i[
          octo_name
          octo4
          step_two
          fail_final
        ]
      end

      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            step_one: nil,
            step_two: false,
            some_action: nil,
            some_service: nil,
            final: nil,
            fail_final: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end
end
