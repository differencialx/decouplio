# frozen_string_literal: true

RSpec.describe 'Decouplio::Action wrap with class cases' do
  include_context 'with basic spec setup'

  let(:input_params) do
    {
      w1: -> { w1 },
      f1: -> { f1 }
    }
  end
  let(:w1) { nil }
  let(:f1) { nil }

  before do
    allow(StubDummy).to receive(:call)
  end

  shared_examples 'calls StubDummy 2 times' do
    it 'calls StubDummy 2 times' do
      action
      expect(StubDummy).to have_received(:call).twice
    end
  end

  shared_examples 'calls StubDummy once' do
    it 'calls StubDummy once' do
      action
      expect(StubDummy).to have_received(:call).once
    end
  end

  describe 'simple wrap with class' do
    let(:action_block) { wrap_with_class }

    context %i[
      step_one
      wrap_name
      wrap_step_one
      wrap_step_two
      step_two
    ] do
      let(:w1) { true }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: described_class,
          errors: {},
          state: {
            step_one: 'Success',
            wrap_step_one: true,
            wrap_step_two: 'Success',
            step_two: 'Success',
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'calls StubDummy 2 times'
    end

    context %i[
      step_one
      wrap_name
      wrap_step_one
      fail_one
    ] do
      let(:w1) { false }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: described_class,
          errors: {},
          state: {
            step_one: 'Success',
            wrap_step_one: false,
            wrap_step_two: nil,
            step_two: nil,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'calls StubDummy 2 times'
    end
  end

  describe 'wrap with class on_success to failure' do
    let(:action_block) { wrap_with_class_on_success_to_failure }

    context %i[
      step_one
      wrap_name
      wrap_step_one
      wrap_step_two
      fail_one
    ] do
      let(:w1) { true }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: described_class,
          errors: {},
          state: {
            step_one: 'Success',
            wrap_step_one: true,
            wrap_step_two: 'Success',
            step_two: nil,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'calls StubDummy 2 times'
    end

    context %i[
      step_one
      wrap_name
      wrap_step_one
      fail_one
    ] do
      let(:w1) { false }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: described_class,
          errors: {},
          state: {
            step_one: 'Success',
            wrap_step_one: false,
            wrap_step_two: nil,
            step_two: nil,
            fail_one: 'Failure'
          }
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'calls StubDummy 2 times'
    end
  end

  describe 'wrap with class on_failure to success' do
    let(:action_block) { wrap_with_class_on_failure_to_success }

    context %i[
      step_one
      wrap_name
      wrap_step_one
      wrap_step_two
      step_two
    ] do
      let(:w1) { true }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: described_class,
          errors: {},
          state: {
            step_one: 'Success',
            wrap_step_one: true,
            wrap_step_two: 'Success',
            step_two: 'Success',
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'calls StubDummy 2 times'
    end

    context %i[
      step_one
      wrap_name
      wrap_step_one
      step_two
    ] do
      let(:w1) { false }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: described_class,
          errors: {},
          state: {
            step_one: 'Success',
            wrap_step_one: false,
            wrap_step_two: nil,
            step_two: 'Success',
            fail_one: nil
          }
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'calls StubDummy 2 times'
    end
  end

  describe 'wrap with class on_error finish_him' do
    let(:action_block) { wrap_with_class_resq_on_error_finish_him }

    context %i[
      step_one
      wrap_name
      wrap_step_one
      wrap_step_two
      step_two
    ] do
      let(:w1) { true }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: described_class,
          errors: {},
          state: {
            step_one: 'Success',
            wrap_step_one: true,
            wrap_step_two: 'Success',
            step_two: 'Success',
            fail_one: nil,
            handle_resq: nil
          }
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'calls StubDummy 2 times'
    end

    context %i[
      step_one
      wrap_name
      wrap_step_one
      handle_resq
    ] do
      let(:error_message) { 'Error message' }
      let(:w1) { raise error_message }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: described_class,
          errors: {},
          state: {
            step_one: 'Success',
            wrap_step_one: nil,
            wrap_step_two: nil,
            step_two: nil,
            fail_one: nil,
            handle_resq: error_message
          }
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'calls StubDummy once'
    end
  end

  describe 'wrap with class resq' do
    let(:action_block) { wrap_with_class_resq }

    context %i[
      step_one
      wrap_name
      wrap_step_one
      wrap_step_two
      step_two
    ] do
      let(:w1) { true }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: described_class,
          errors: {},
          state: {
            step_one: 'Success',
            wrap_step_one: true,
            wrap_step_two: 'Success',
            step_two: 'Success',
            fail_one: nil,
            handle_resq: nil
          }
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'calls StubDummy 2 times'
    end

    context %i[
      step_one
      wrap_name
      wrap_step_one
      handle_resq
      fail_one
    ] do
      let(:error_message) { 'Error message' }
      let(:w1) { raise error_message }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: described_class,
          errors: {},
          state: {
            step_one: 'Success',
            wrap_step_one: nil,
            wrap_step_two: nil,
            step_two: nil,
            fail_one: 'Failure',
            handle_resq: error_message
          }
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'calls StubDummy once'
    end
  end

  describe 'wrap with class finish_him on_success' do
    let(:action_block) { wrap_with_class_finish_him_on_success }

    context %i[
      step_one
      wrap_name
      wrap_step_one
      wrap_step_two
    ] do
      let(:w1) { true }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: described_class,
          errors: {},
          state: {
            step_one: 'Success',
            wrap_step_one: true,
            wrap_step_two: 'Success',
            step_two: nil,
            fail_one: nil,
            handle_resq: nil
          }
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'calls StubDummy 2 times'
    end

    context %i[
      step_one
      wrap_name
      wrap_step_one
      fail_one
    ] do
      let(:error_message) { 'Error message' }
      let(:w1) { false }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: described_class,
          errors: {},
          state: {
            step_one: 'Success',
            wrap_step_one: false,
            wrap_step_two: nil,
            step_two: nil,
            fail_one: 'Failure',
            handle_resq: nil
          }
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'calls StubDummy 2 times'
    end
  end

  describe 'wrap with class from fail to wrap' do
    let(:action_block) { wrap_with_class_from_fail_to_wrap }

    context %i[
      step_one
      fail_one
      wrap_name
      wrap_step_one
      wrap_step_two
      step_two
    ] do
      let(:w1) { true }
      let(:f1) { true }
      let(:expected_state) do
        {
          action_status: :success,
          railway_flow: described_class,
          errors: {},
          state: {
            step_one: false,
            fail_one: true,
            wrap_step_one: true,
            wrap_step_two: 'Success',
            step_two: 'Success',
            fail_two: nil,
            handle_resq: nil
          }
        }
      end

      it_behaves_like 'check action state'
      it_behaves_like 'calls StubDummy 2 times'
    end

    context %i[
      step_one
      fail_one
      fail_two
    ] do
      let(:w1) { true }
      let(:f1) { false }
      let(:expected_state) do
        {
          action_status: :failure,
          railway_flow: described_class,
          errors: {},
          state: {
            step_one: false,
            fail_one: false,
            wrap_step_one: nil,
            wrap_step_two: nil,
            step_two: nil,
            fail_two: 'Failure',
            handle_resq: nil
          }
        }
      end

      it_behaves_like 'check action state'
    end
  end
end
