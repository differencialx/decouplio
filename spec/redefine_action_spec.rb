RSpec.describe 'Redefine actions' do
  let(:first_definition) do
    class One < Decouplio::Action
      logic do
        step :step_one
        step :Step_two
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end
    end
  end

  let(:second_definition) do
    class One < Decouplio::Action
      logic do
        step :step_three
        step :step_four
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def step_four(**)
        ctx[:step_four] = 'Success'
      end
    end
  end

  context 'when action was redefined' do
    let(:expected_message) do
      format(
        Decouplio::Const::Validations::Action::VALIDATION_ERROR_MESSAGE,
        Decouplio::Const::Colors::YELLOW,
        'One',
        Decouplio::Const::Colors::NO_COLOR
      )

    end

    it 'raises error' do
      first_definition
      expect { second_definition }.to raise_proper_error(
        Decouplio::Errors::ActionRedefinitionError,
        expected_message
      )
    end
  end
end
