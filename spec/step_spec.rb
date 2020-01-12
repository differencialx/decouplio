# frozen_string_literal: true

RSpec.describe 'Decouplio::Action steps specs' do
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

    context 'steps' do
      let(:action_block) { steps }
      let(:expected_result) { string_param }

      it 'success' do
        expect(action).to be_success
      end

      it 'sets result' do
        expect(action[:result]).to eq expected_result
      end
    end
  end
end
