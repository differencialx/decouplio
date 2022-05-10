# frozen_string_literal: true

shared_context 'with after block setup' do
  subject(:action) { dummy_instance.call(input_params, &after_block) }

  let(:input_params) { {} }
  let(:after_block) { ->(_outcome) { 'Stub' } }

  let(:error_message) { 'Error message' }

  let(:dummy_instance) do
    Class.new(Decouplio::Action, &action_block)
  end
end
