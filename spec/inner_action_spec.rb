# frozen_string_literal: true

RSpec.describe 'Decouplio::Action inner action specs' do
  context '#call' do
    let(:error_message) { 'Error message' }
    subject(:action) { dummy_instance.call(input_params) }

    let(:dummy_instance) do
      Class.new(Decouplio::Action, &action_block)
    end

    let(:string_param) { '4' }
    let(:integer_param) { 4 }
    let(:input_params) do
      {
        string_param: string_param,
        integer_param: integer_param
      }
    end

    context 'nested steps' do
      let(:action_block) { inner_action }
      let(:input_params) do
        {
          integer_param: integer_param,
          inner_action_param: inner_action_param
        }
      end
      let(:inner_action_param) { 42 }
      let(:expected_result) { 80 }

      context 'success' do
        it 'success' do
          expect(action).to be_success
        end

        it 'sets result' do
          expect(action[:result]).to eq expected_result
        end
      end

      context 'failure' do
        let(:inner_action_param) { 41 }
        let(:expected_errors) { { invalid_inner_action_param: ['Invalid inner_action_param'] } }

        it 'fails' do
          expect(action).to be_failure
        end

        it 'sets errors to parent action' do
          expect(action.errors).not_to be_empty
          expect(action.errors).to match expected_errors
        end
      end
    end
  end
end
