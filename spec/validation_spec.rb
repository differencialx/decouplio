# frozen_string_literal: true

RSpec.describe 'Decouplio::Action validation specs' do
  describe '#call' do
    include_context 'with basic spec setup'

    context 'when validates with dry schema' do
      let(:action_block) { validations }
      let(:string_param) { false }
      let(:expected_errors) { { string_param: ['must be a string'] } }

      it_behaves_like 'fails with error'
    end

    context 'when custom validations are used' do
      let(:action_block) { custom_validations }
      let(:string_param) { '3' }
      let(:expected_errors) { { invalid_string_param: ['Invalid string param'] } }

      it_behaves_like 'fails with error'
    end
  end
end
