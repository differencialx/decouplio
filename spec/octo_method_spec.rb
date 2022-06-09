# frozen_string_literal: true

RSpec.describe 'Octo with method' do
  include_context 'with basic spec setup'

  let(:input_params) do
    {
      p1: p1,
      p2: p2,
      p3: p3,
      octo_key: octo_key
    }
  end
  let(:p1) { nil }
  let(:p2) { nil }
  let(:p3) { nil }
  let(:octo_key) { nil }

  context 'when octo with method' do
    let(:action_block) { when_octo_with_method }

    context 'when octo_key octo1' do
      let(:octo_key) { :octo1 }

      context 'when palp_one_step success' do
        let(:p1) { -> { true } }
        let(:railway_flow) { %i[step_one octo_name palp_one_step step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: 'Success',
              fail_one: nil,
              palp_one_step: true,
              palp_two_step: nil,
              palp_three_step: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when palp_one_step failure' do
        let(:p1) { -> { false } }
        let(:railway_flow) { %i[step_one octo_name palp_one_step fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: nil,
              fail_one: 'Failure',
              palp_one_step: false,
              palp_two_step: nil,
              palp_three_step: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when octo_key octo2' do
      let(:octo_key) { :octo2 }

      context 'when palp_two_step success' do
        let(:p2) { -> { true } }
        let(:railway_flow) { %i[step_one octo_name palp_two_step step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: 'Success',
              fail_one: nil,
              palp_one_step: nil,
              palp_two_step: true,
              palp_three_step: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when palp_two_step failure' do
        let(:p2) { -> { false } }
        let(:railway_flow) { %i[step_one octo_name palp_two_step fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: nil,
              fail_one: 'Failure',
              palp_one_step: nil,
              palp_two_step: false,
              palp_three_step: nil
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end

    context 'when octo_key octo3' do
      let(:octo_key) { :octo3 }

      context 'when palp_three_step success' do
        let(:p3) { -> { true } }
        let(:railway_flow) { %i[step_one octo_name palp_three_step step_two] }
        let(:expected_state) do
          {
            action_status: :success,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: 'Success',
              fail_one: nil,
              palp_one_step: nil,
              palp_two_step: nil,
              palp_three_step: true
            }
          }
        end

        it_behaves_like 'check action state'
      end

      context 'when palp_three_step failure' do
        let(:p3) { -> { false } }
        let(:railway_flow) { %i[step_one octo_name palp_three_step fail_one] }
        let(:expected_state) do
          {
            action_status: :failure,
            railway_flow: railway_flow,
            errors: {},
            state: {
              step_one: 'Success',
              step_two: nil,
              fail_one: 'Failure',
              palp_one_step: nil,
              palp_two_step: nil,
              palp_three_step: false
            }
          }
        end

        it_behaves_like 'check action state'
      end
    end
  end

  context 'when octo with method nad octo_key' do
    let(:action_block) { when_octo_with_method_and_ctx_key }

    interpolation_values = [
      '{:ctx_key=>:octo_key, :method=>:octo_key}',
      '"ctx_key" option(s) is not allowed along with "method" option(s)',
      Decouplio::Const::Validations::Octo::ALLOWED_OPTIONS_MESSAGE,
      Decouplio::Const::Validations::Octo::MANUAL_URL
    ]
    message = Decouplio::Const::Validations::Octo::VALIDATION_ERROR_MESSAGE % interpolation_values

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::OctoControversialKeysError,
                    message: message
  end
end
