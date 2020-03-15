# frozen_string_literal: true

RSpec.describe 'Decouplio::Action prepare params specs' do
  describe '#call' do
    include_context 'with basic spec setup'
    let(:input_params) do
      {
        args: {
          id: 'id',
          name: 'name'
        },
        current_user: 'User'
      }
    end
    let(:expected_params) do
      {
        id: 'id',
        args: { name: 'name' },
        user: 'User'
      }
    end

    describe 'prepare_params' do
      context 'when success' do
        context 'with block' do
          let(:action_block) { prepare_params_block }

          it 'success' do
            expect(action).to be_success
          end

          it 'modifies params' do
            expect(action[:params]).to match(expected_params)
          end
        end

        context 'with method' do
          let(:action_block) { prepare_params_method }

          it 'success' do
            expect(action).to be_success
          end

          it 'modifies params' do
            expect(action[:params]).to match(expected_params)
          end
        end

        context 'with inner action' do
          let(:action_block) { prepare_params_with_action }

          it 'success' do
            expect(action).to be_success
          end

          it 'modifies params' do
            expect(action[:params]).to match(expected_params)
          end
        end
      end

      context 'when failure' do
        context 'when prepare params returns nil' do
          let(:action_block) { prepare_params_returns_nil }

          it 'raises error' do
            expect{ action }.to raise_error(
              Decouplio::Errors::PrepareParamsError,
              'Prepare params should return a Hash'
            )
          end
        end

        context 'when prepare params reutrns array' do
          let(:action_block) { prepare_params_returns_array }

          it 'raises error' do
            expect{ action }.to raise_error(
              Decouplio::Errors::PrepareParamsError,
              'Prepare params should return a Hash'
            )
          end
        end

        context 'when step and block is given' do
          let(:action_block) { prepare_params_step_and_class_is_given }

          it 'raises error' do
            expect{ action }.to raise_error(
              Decouplio::Errors::PrepareParamsError,
              'Method or action class or block should be provided for prepare params'
            )
          end
        end
      end
    end
  end
end
