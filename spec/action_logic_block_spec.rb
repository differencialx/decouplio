# frozen_string_literal: true

RSpec.describe 'Action logic block' do
  context 'when action was redefined' do
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
    let(:expected_message) do
      format(
        Decouplio::Const::Validations::Logic::VALIDATION_ERROR_MESSAGE,
        format(
          Decouplio::Const::Validations::Logic::REDEFINITION,
          'One'
        )
      )
    end

    it 'raises error' do
      first_definition
      expect { second_definition }.to raise_proper_error(
        Decouplio::Errors::LogicRedefinitionError,
        expected_message
      )
    end
  end

  context 'when two logic blocks was defined' do
    context 'when two not empty logic blocks' do
      let(:action_class) do
        class Two < Decouplio::Action
          logic do
            step :step_one
          end

          def step_one(**)
            ctx[:step_one] = 'Success'
          end

          logic do
            step :step_two
          end

          def step_two(**)
            ctx[:step_two] = 'Success'
          end
        end
      end

      let(:expected_message) do
        format(
          Decouplio::Const::Validations::Logic::VALIDATION_ERROR_MESSAGE,
          format(
            Decouplio::Const::Validations::Logic::REDEFINITION,
            'Two'
          )
        )
      end

      it 'raises error' do
        expect { action_class }.to raise_proper_error(
          Decouplio::Errors::LogicRedefinitionError,
          expected_message
        )
      end
    end

    context 'when first logic is defined and second is empty' do
      let(:action_class) do
        class Three < Decouplio::Action
          logic do
            step :step_one
          end

          logic do
          end

          def step_one(**)
            ctx[:step_one] = 'Success'
          end
        end
      end

      let(:expected_message) do
        format(
          Decouplio::Const::Validations::Logic::VALIDATION_ERROR_MESSAGE,
          format(
            Decouplio::Const::Validations::Logic::REDEFINITION,
            'Three'
          )
        )
      end

      it 'raises error' do
        expect { action_class }.to raise_proper_error(
          Decouplio::Errors::LogicRedefinitionError,
          expected_message
        )
      end
    end

    context 'when first logic is empty and second is defined' do
      let(:action_class) do
        class Four < Decouplio::Action
          logic do
          end

          logic do
            step :step_one
          end

          def step_one(**)
            ctx[:step_one] = 'Success'
          end
        end
      end

      let(:expected_message) do
        format(
          Decouplio::Const::Validations::Logic::VALIDATION_ERROR_MESSAGE,
          format(
            Decouplio::Const::Validations::Logic::NOT_DEFINED,
            'Four'
          )
        )
      end

      it 'raises error' do
        expect { action_class }.to raise_proper_error(
          Decouplio::Errors::LogicIsNotDefinedError,
          expected_message
        )
      end
    end

    context 'when first logic is empty and second is empty' do
      let(:action_class) do
        class Five < Decouplio::Action
          logic do
          end

          logic do
            step :step_one
          end

          def step_one(**)
            ctx[:step_one] = 'Success'
          end
        end
      end

      let(:expected_message) do
        format(
          Decouplio::Const::Validations::Logic::VALIDATION_ERROR_MESSAGE,
          format(
            Decouplio::Const::Validations::Logic::NOT_DEFINED,
            'Five'
          )
        )
      end

      it 'raises error' do
        expect { action_class }.to raise_proper_error(
          Decouplio::Errors::LogicIsNotDefinedError,
          expected_message
        )
      end
    end
  end

  context 'when one logic block was defined' do
    context 'when logic block was not passed' do
      let(:action_class) do
        class Six < Decouplio::Action
          logic
        end
      end
      let(:expected_message) do
        format(
          Decouplio::Const::Validations::Logic::VALIDATION_ERROR_MESSAGE,
          format(
            Decouplio::Const::Validations::Logic::NOT_DEFINED,
            'Six'
          )
        )
      end

      it 'raises error' do
        expect { action_class }.to raise_proper_error(
          Decouplio::Errors::LogicIsNotDefinedError,
          expected_message
        )
      end
    end

    context 'when logic block without any flow' do
      let(:action_class) do
        class Seven < Decouplio::Action
          logic do
          end
        end
      end
      let(:expected_message) do
        format(
          Decouplio::Const::Validations::Logic::VALIDATION_ERROR_MESSAGE,
          format(
            Decouplio::Const::Validations::Logic::NOT_DEFINED,
            'Seven'
          )
        )
      end

      it 'raises error' do
        expect { action_class }.to raise_proper_error(
          Decouplio::Errors::LogicIsNotDefinedError,
          expected_message
        )
      end
    end
  end
end
