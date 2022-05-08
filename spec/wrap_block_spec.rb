# frozen_string_literal: true

RSpec.describe 'Wrap block' do
  context 'when one wrap block was defined' do
    context 'when palp block was not passed' do
      let(:action_class) do
        class Eight < Decouplio::Action
          logic do
            wrap
          end
        end
      end
      let(:expected_message) do
        Decouplio::Const::Validations::Wrap::NOT_DEFINED
      end

      it 'raises error' do
        expect { action_class }.to raise_proper_error(
          Decouplio::Errors::WrapBlockIsNotDefinedError,
          expected_message
        )
      end
    end
  end
end
