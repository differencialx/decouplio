# frozen_string_literal: true

shared_context 'with basic spec setup' do
  subject(:action) { dummy_instance.call(**input_params) }
  subject(:action!) { dummy_instance.call!(**input_params) }

  let(:input_params) { {} }

  let(:error_message) { 'Error message' }

  let(:dummy_instance) do
    Class.new(Decouplio::Action, &action_block)
  end
end
