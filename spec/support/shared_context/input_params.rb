# frozen_string_literal: true

shared_context 'with input params' do
  let(:string_param) { '4' }
  let(:integer_param) { 4 }
  let(:input_params) do
    {
      string_param: string_param,
      integer_param: integer_param
    }
  end
end
