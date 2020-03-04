# frozen_string_literal: true

RSpec.describe 'Decouplio::Action gendalf cases' do
  describe '#call' do
    include_context 'with basic spec setup'
    describe 'steps' do
      let(:id) { 1 }
      let(:not_allowed_id) { 2 }
      let(:user) { double('User', id: id) } #fuck of rubocop rspec, I don't have models
      let(:record) { double('Record', user_id: id) } #fuck of rubocop rspec, I don't have models
      let(:input_params) do
        {
          user: user,
          model: record
        }
      end

      context 'when success' do
        before do
          allow(StubDummy).to receive(:call) { true }
        end

        context 'when authorization success' do
          let(:action_block) { gendalf_default }

          it 'sets result to Success' do
            expect(action[:result]).to eq 'Success'
          end

          it 'success' do
            expect(action).to be_success
          end

          it 'gendalf?' do
            expect(action.gendalf?).to be true
          end
        end

        context 'when custom user key provided' do
          let(:input_params) do
            {
              current_user: user,
              model: record
            }
          end
          let(:action_block) { gendalf_custom_user_key }

          it 'sets result to Success' do
            expect(action[:result]).to eq 'Success'
          end

          it 'success' do
            expect(action).to be_success
          end

          it 'gendalf?' do
            expect(action.gendalf?).to be true
          end

          it 'sets model' do
            expect(action[:model]).to eq record
          end
        end

        context 'when custom model key provided' do
          let(:input_params) do
            {
              user: user,
              model: record
            }
          end
          let(:action_block) { gendalf_custom_model_key }

          it 'sets result to Success' do
            expect(action[:result]).to eq 'Success'
          end

          it 'success' do
            expect(action).to be_success
          end

          it 'gendalf?' do
            expect(action.gendalf?).to be true
          end

          it 'sets model' do
            expect(action[:record]).to eq record
          end
        end
      end

      context 'when fails' do
        context 'when access denied' do
          let(:action_block) { gendalf_fails_with_error }
          let(:record) { double('Record', user_id: not_allowed_id) } #fuck of rubocop rspec, I don't have models

          before do
            allow(StubDummy).to receive(:call) { false }
          end

          it 'does not call step one' do
            expect(action[:result]).to be_nil
          end

          it 'fails' do
            expect(action).to be_failure
          end

          it 'gendalf?' do
            expect(action.gendalf?).to be false
          end

          it 'sets errors' do
            expect(action.errors).to match(gendalf: ['You shall not pass!', 'GendalfCases::GendalfDummy#index?'])
          end
        end
      end
    end
  end
end
