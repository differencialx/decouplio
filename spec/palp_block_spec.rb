# frozen_string_literal: true

RSpec.describe 'Palp block' do
  context 'when one palp block was defined' do
    context 'when palp block was not passed' do
      let(:action_class) do
        class Nine < Decouplio::Action
          logic do
            palp :palp_name
          end
        end
      end
      let(:expected_message) do
        Decouplio::Const::Validations::Palp::NOT_DEFINED
      end

      it 'raises error' do
        expect { action_class }.to raise_proper_error(
          Decouplio::Errors::PalpBlockIsNotDefinedError,
          expected_message
        )
      end
    end
  end
end
