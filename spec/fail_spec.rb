# frozen_string_literal: true

RSpec.describe 'Fail step' do
  context 'when fail is the first step' do
    let(:action_class) do
      class Ten < Decouplio::Action
        logic do
          fail :fail_one
        end
      end
    end
    let(:expected_message) do
      Decouplio::Const::Validations::Fail::FIRST_STEP
    end

    it 'raises error' do
      expect { action_class }.to raise_proper_error(
        Decouplio::Errors::FailBlockIsNotDefinedError,
        expected_message
      )
    end
  end
end
