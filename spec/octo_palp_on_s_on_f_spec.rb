# frozen_string_literal: true

RSpec.describe 'Octo palps on_s on_f cases' do
  include_context 'with basic spec setup'

  let(:input_params) do
    {
      octo_key: octo_key,
      oc1: -> { oc1 },
      pl1: -> { pl1 },
      pl2: -> { pl2 },
      on_s_on_f_act: -> { some_action_step },
      on_s_on_f_ser: -> { some_service_step }
    }
  end
  let(:octo_key) { nil }
  let(:oc1) { nil }
  let(:pl1) { nil }
  let(:pl2) { nil }
  let(:some_action_step) { nil }
  let(:some_service_step) { nil }
  let(:action_block) { when_octo_on_s_on_f }
  let(:error_message) { 'error message' }

  context 'when octo1' do
    let(:octo_key) { :octo1 }

    context 'when success' do
      let(:oc1) { true }
      let(:railway_flow) do
        %i[
          octo_name
          octo1
          octo_one
        ]
      end

      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: nil,
            octo_failure: nil,
            octo_error: nil,
            octo_one: true,
            octo_one_failure: nil,
            octo_two_error: nil,
            octo_three_success: nil,
            palp_one_step: nil,
            palp_two_step: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when failure' do
      let(:oc1) { false }
      let(:railway_flow) do
        %i[
          octo_name
          octo1
          octo_one
          octo_one_failure
        ]
      end

      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: nil,
            octo_failure: nil,
            octo_error: nil,
            octo_one: false,
            on_s_on_f_action: nil,
            on_s_on_f_service: nil,
            octo_one_failure: 'Failure',
            octo_two_error: nil,
            octo_three_success: nil,
            palp_one_step: nil,
            palp_two_step: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when error' do
      let(:oc1) { raise ArgumentError, error_message }
      let(:railway_flow) do
        %i[
          octo_name
          octo1
          octo_one
          handle_error
          octo_error
        ]
      end

      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: nil,
            octo_failure: nil,
            octo_error: 'Error',
            octo_one: nil,
            on_s_on_f_action: nil,
            on_s_on_f_service: nil,
            octo_one_failure: nil,
            octo_two_error: nil,
            octo_three_success: nil,
            palp_one_step: nil,
            palp_two_step: nil,
            handle_error: error_message
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
          OctoPalpOnSOnFCases::OnSOnFAction
          on_s_on_f_action
          octo_success
        ]
      end

      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: 'Success',
            octo_failure: nil,
            octo_error: nil,
            octo_one: nil,
            on_s_on_f_action: true,
            on_s_on_f_service: nil,
            octo_one_failure: nil,
            octo_two_error: nil,
            octo_three_success: nil,
            palp_one_step: nil,
            palp_two_step: nil,
            handle_error: nil
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
          OctoPalpOnSOnFCases::OnSOnFAction
          on_s_on_f_action
        ]
      end

      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: nil,
            octo_failure: nil,
            octo_error: nil,
            octo_one: nil,
            on_s_on_f_action: false,
            on_s_on_f_service: nil,
            octo_one_failure: nil,
            octo_two_error: nil,
            octo_three_success: nil,
            palp_one_step: nil,
            palp_two_step: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when error' do
      let(:some_action_step) { raise ArgumentError, error_message }
      let(:railway_flow) do
        %i[
          octo_name
          octo2
          OctoPalpOnSOnFCases::OnSOnFAction
          on_s_on_f_action
          handle_error
          octo_two_error
        ]
      end

      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: nil,
            octo_failure: nil,
            octo_error: nil,
            octo_one: nil,
            on_s_on_f_action: nil,
            on_s_on_f_service: nil,
            octo_one_failure: nil,
            octo_two_error: 'Error',
            octo_three_success: nil,
            palp_one_step: nil,
            palp_two_step: nil,
            handle_error: error_message
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
          OctoPalpOnSOnFCases::OnSOnFService
          octo_three_success
        ]
      end

      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: nil,
            octo_failure: nil,
            octo_error: nil,
            octo_one: nil,
            on_s_on_f_action: nil,
            on_s_on_f_service: true,
            octo_one_failure: nil,
            octo_two_error: nil,
            octo_three_success: 'Success',
            palp_one_step: nil,
            palp_two_step: nil,
            handle_error: nil
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
          OctoPalpOnSOnFCases::OnSOnFService
          octo_failure
        ]
      end

      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: nil,
            octo_failure: 'Failure',
            octo_error: nil,
            octo_one: nil,
            on_s_on_f_action: nil,
            on_s_on_f_service: false,
            octo_one_failure: nil,
            octo_two_error: nil,
            octo_three_success: nil,
            palp_one_step: nil,
            palp_two_step: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when error' do
      let(:some_service_step) { raise ArgumentError, error_message }
      let(:railway_flow) do
        %i[
          octo_name
          octo3
          OctoPalpOnSOnFCases::OnSOnFService
          handle_error
        ]
      end

      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: nil,
            octo_failure: nil,
            octo_error: nil,
            octo_one: nil,
            on_s_on_f_action: nil,
            on_s_on_f_service: nil,
            octo_one_failure: nil,
            octo_two_error: nil,
            octo_three_success: nil,
            palp_one_step: nil,
            palp_two_step: nil,
            handle_error: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when octo4' do
    let(:octo_key) { :octo4 }

    context 'when success' do
      let(:pl1) { true }
      let(:railway_flow) do
        %i[
          octo_name
          octo4
          palp_one_step
          octo_one_failure
        ]
      end

      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: nil,
            octo_failure: nil,
            octo_error: nil,
            octo_one: nil,
            on_s_on_f_action: nil,
            on_s_on_f_service: nil,
            octo_one_failure: 'Failure',
            octo_two_error: nil,
            octo_three_success: nil,
            palp_one_step: true,
            palp_two_step: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when failure' do
      let(:pl1) { false }
      let(:railway_flow) do
        %i[
          octo_name
          octo4
          palp_one_step
          octo_three_success
        ]
      end

      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: nil,
            octo_failure: nil,
            octo_error: nil,
            octo_one: nil,
            on_s_on_f_action: nil,
            on_s_on_f_service: nil,
            octo_one_failure: nil,
            octo_two_error: nil,
            octo_three_success: 'Success',
            palp_one_step: false,
            palp_two_step: nil,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when error' do
      let(:pl1) { raise ArgumentError, error_message }
      let(:railway_flow) do
        %i[
          octo_name
          octo4
          palp_one_step
          handle_error
          octo_three_success
        ]
      end

      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: nil,
            octo_failure: nil,
            octo_error: nil,
            octo_one: nil,
            on_s_on_f_action: nil,
            on_s_on_f_service: nil,
            octo_one_failure: nil,
            octo_two_error: nil,
            octo_three_success: 'Success',
            palp_one_step: nil,
            palp_two_step: nil,
            handle_error: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end

  context 'when octo5' do
    let(:octo_key) { :octo5 }

    context 'when success' do
      let(:pl2) { true }
      let(:railway_flow) do
        %i[
          octo_name
          octo5
          palp_two_step
          octo_success
        ]
      end

      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: 'Success',
            octo_failure: nil,
            octo_error: nil,
            octo_one: nil,
            on_s_on_f_action: nil,
            on_s_on_f_service: nil,
            octo_one_failure: nil,
            octo_two_error: nil,
            octo_three_success: nil,
            palp_one_step: nil,
            palp_two_step: true,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when failure' do
      let(:pl2) { false }
      let(:railway_flow) do
        %i[
          octo_name
          octo5
          palp_two_step
          octo_failure
        ]
      end

      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: nil,
            octo_failure: 'Failure',
            octo_error: nil,
            octo_one: nil,
            on_s_on_f_action: nil,
            on_s_on_f_service: nil,
            octo_one_failure: nil,
            octo_two_error: nil,
            octo_three_success: nil,
            palp_one_step: nil,
            palp_two_step: false,
            handle_error: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end

    context 'when error' do
      let(:pl2) { raise ArgumentError, error_message }
      let(:railway_flow) do
        %i[
          octo_name
          octo5
          palp_two_step
          handle_error
          octo_error
        ]
      end

      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: railway_flow,
          errors: {},
          state: {
            octo_success: nil,
            octo_failure: nil,
            octo_error: 'Error',
            octo_one: nil,
            on_s_on_f_action: nil,
            on_s_on_f_service: nil,
            octo_one_failure: nil,
            octo_two_error: nil,
            octo_three_success: nil,
            palp_one_step: nil,
            palp_two_step: nil,
            handle_error: error_message
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end
end
