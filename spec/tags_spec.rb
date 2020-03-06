# frozen_string_literal: true

RSpec.describe 'Decouplio::Action gendalf cases' do
  describe '#call' do
    include_context 'with basic spec setup'
    describe 'tags' do
      context 'when success' do
        let(:action_block) { tags_main }

        it 'sets step_one to Success' do
          expect(action[:step_one]).to eq 'Success'
        end

        it 'does not set step_two' do
          expect(action[:step_two]).to be_nil
        end

        it 'sets step_three to Success' do
          expect(action[:step_three]).to eq 'Success'
        end

        it 'success' do
          expect(action).to be_failure
        end

        it 'step_one_success?' do
          expect(action.step_one_success?).to be true
        end

        it 'step_two_success?' do
          expect(action.step_two_success?).to be false
        end

        it 'step_three_success?' do
          expect(action.step_three_success?).to be true
        end
      end

      context 'with rescue_for and wrap block' do
        let(:action_block) { tags_rescue_for_wrap_success }

        context 'when success' do
          it 'sets step_one to Success' do
            expect(action[:step_one]).to eq 'Success'
          end

          it 'does not set step_two' do
            expect(action[:step_two]).to eq 'Success'
          end

          it 'sets step_three to Success' do
            expect(action[:step_three]).to be_nil
          end

          it 'success' do
            expect(action).to be_success
          end

          it 'step_one_success?' do
            expect(action.step_one_success?).to be true
          end

          it 'step_two_success?' do
            expect(action.step_two_success?).to be true
          end

          it 'step_three_success?' do
            expect(action.step_three_success?).to be true
          end

          it 'wrap success' do
            expect(action.wrap_success?).to be true
          end
        end

        context 'when fails' do
          let(:error_message) { 'Error' }

          before do
            allow(StubDummy).to receive(:call)
              .and_raise(StandardError, error_message)
          end

          it 'sets step_one to Success' do
            expect(action[:step_one]).to eq 'Success'
          end

          it 'does not set step_two' do
            expect(action[:step_two]).to eq 'Success'
          end

          it 'sets step_three to Success' do
            expect(action[:step_three]).to be_nil
          end

          it 'success' do
            expect(action).to be_failure
          end

          it 'step_one_success?' do
            expect(action.step_one_success?).to be true
          end

          it 'step_two_success?' do
            expect(action.step_two_success?).to be true
          end

          it 'step_three_success?' do
            expect(action.step_three_success?).to be false
          end

          it 'wrap success' do
            expect(action.wrap_success?).to be false
          end
        end
      end
    end
  end
end
