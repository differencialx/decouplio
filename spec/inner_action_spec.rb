# frozen_string_literal: true

RSpec.describe 'Decouplio::Action inner action specs' do
  describe '#call' do
    include_context 'with basic spec setup'
    include_context 'with input params'

    let(:action_block) { inner_action }
    let(:input_params) do
      {
        integer_param: integer_param,
        inner_action_param: inner_action_param
      }
    end
    let(:inner_action_param) { 42 }
    let(:expected_result) { 80 }

    context 'when inner action success' do
      it 'success' do
        expect(action).to be_success
      end

      it 'sets result' do
        expect(action[:result]).to eq expected_result
      end
    end

    context 'when inner action fails' do
      let(:inner_action_param) { 41 }
      let(:expected_errors) { { invalid_inner_action_param: ['Invalid inner_action_param'] } }

      it_behaves_like 'fails with error'
    end
  end
end
