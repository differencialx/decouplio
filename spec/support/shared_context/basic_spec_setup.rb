# frozen_string_literal: true

shared_context 'with basic spec setup' do
  subject(:action) { dummy_instance.call(input_params) }

  let(:error_message) { 'Error message' }

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
end
