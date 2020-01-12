# frozen_string_literal: true

RSpec.describe 'Decouplio::Action validation specs' do
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

    context 'validations' do
      let(:action_block) { validations }
      let(:string_param) { false }
      let(:expected_errors) { { string_param: ['must be a string'] } }

      it 'sets errors' do
        expect(action.errors).not_to be_empty
        expect(action.errors).to match expected_errors
      end

      it 'fails' do
        expect(action).to be_failure
      end
    end

    context 'custom validations' do
      let(:action_block) { custom_validations }
      let(:string_param) { '3' }
      let(:expected_errors) { { invalid_string_param: ['Invalid string param'] } }

      it 'sets errors' do
        expect(action.errors).not_to be_empty
        expect(action.errors).to match expected_errors
      end

      it 'fails' do
        expect(action).to be_failure
      end
    end
  end
end
