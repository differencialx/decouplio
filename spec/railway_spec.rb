# frozen_string_literal: true

RSpec.describe 'Decouplio::Action railway specs' do
  include_context 'with basic spec setup'

  describe '#call' do
    let(:input_params) do
      { param1: param1, param2: param2 }
    end
    let(:param1) { 'param1' }
    let(:param2) { nil }

    describe 'success_way' do
      let(:action_block) { success_way }
      let(:railway_flow) { %i[model assign_result] }

      it 'success' do
        expect(action).to be_success
      end

      it 'sets result as param1' do
        expect(action[:result]).to eq param1
      end

      it 'sets railway flow' do
        expect(action.railway_flow).to eq railway_flow
      end
    end

    describe 'failure_way' do
      let(:action_block) { failure_way }
      let(:railway_flow) { %i[model set_error] }
      let(:param1) { nil }

      it 'failure' do
        expect(action).to be_failure
      end

      it 'does not set result as param1' do
        expect(action[:result]).to be_nil
      end

      it 'sets railway flow' do
        expect(action.railway_flow).to eq railway_flow
      end

      it 'sets error message' do
        expect(action[:error]).to eq error_message
      end
    end

    describe 'multiple_failure_way' do
      let(:action_block) { multiple_failure_way }
      let(:railway_flow) { %i[model fail_one fail_two fail_three] }
      let(:param1) { nil }

      it 'failure' do
        expect(action).to be_failure
      end

      it 'does not set result as param1' do
        expect(action[:result]).to be_nil
      end

      it 'sets railway flow' do
        expect(action.railway_flow).to eq railway_flow
      end

      it 'sets error message 1' do
        expect(action[:error1]).to eq 'Error message 1'
      end

      it 'sets error message 2' do
        expect(action[:error2]).to eq 'Error message 2'
      end

      it 'sets error message 3' do
        expect(action[:error3]).to eq 'Error message 3'
      end
    end

    describe 'failure_with_finish_him' do
      let(:action_block) { failure_with_finish_him }
      let(:railway_flow) { %i[model fail_one fail_two] }
      let(:param1) { nil }

      it 'failure' do
        expect(action).to be_failure
      end

      it 'does not set result as param1' do
        expect(action[:result]).to be_nil
      end

      it 'sets railway flow' do
        expect(action.railway_flow).to eq railway_flow
      end

      it 'sets error message 1' do
        expect(action[:error1]).to eq 'Error message 1'
      end

      it 'sets error message 2' do
        expect(action[:error2]).to eq 'Error message 2'
      end

      it 'sets error message 3' do
        expect(action[:error3]).to be_nil
      end
    end

    describe 'conditional_execution_for_step' do
      let(:action_block) { conditional_execution_for_step }
      let(:param1) { 'param1' }

      context 'when assign result should be performed' do
        let(:param2) { true }
        let(:railway_flow) { %i[model assign_result final_step] }

        it 'success' do
          expect(action).to be_success
        end

        it 'sets final step as param1' do
          expect(action[:final_step]).to eq param1
        end

        it 'sets result' do
          expect(action[:result]).to eq param1
        end

        it 'sets railway flow' do
          expect(action.railway_flow).to eq railway_flow
        end
      end

      context 'when assign result should not be performed' do
        let(:param2) { false }
        let(:railway_flow) { %i[model final_step] }

        it 'success' do
          expect(action).to be_success
        end

        it 'sets final step as param1' do
          expect(action[:final_step]).to eq param1
        end

        it 'does not set result' do
          expect(action[:result]).to be_nil
        end

        it 'sets railway flow' do
          expect(action.railway_flow).to eq railway_flow
        end
      end
    end

    describe 'conditional_execution_for_fail' do
      let(:action_block) { conditional_execution_for_fail }
      let(:param1) { nil }

      context 'when assign result should be performed' do
        let(:param2) { true }
        let(:railway_flow) { %i[model fail_one fail_two] }

        it 'failure' do
          expect(action).to be_failure
        end

        it 'sets error message 1' do
          expect(action[:error1]).to eq 'Error message 1'
        end

        it 'sets error message 2' do
          expect(action[:error2]).to eq 'Error message 2'
        end

        it 'does not set result' do
          expect(action[:result]).to be_nil
        end

        it 'sets railway flow' do
          expect(action.railway_flow).to eq railway_flow
        end
      end

      context 'when assign result should not be performed' do
        let(:param2) { false }
        let(:railway_flow) { %i[model fail_two] }

        it 'failure' do
          expect(action).to be_failure
        end

        it 'sets error message 1' do
          expect(action[:error1]).to be_nil
        end

        it 'sets error message 2' do
          expect(action[:error2]).to eq 'Error message 2'
        end

        it 'does not set result' do
          expect(action[:result]).to be_nil
        end

        it 'sets railway flow' do
          expect(action.railway_flow).to eq railway_flow
        end
      end
    end

    describe 'pass_way' do
      let(:action_block) { pass_way }
      let(:railway_flow) { %i[model pass_step assign_result] }
      let(:param2) { 'params2' }

      it 'success' do
        expect(action).to be_success
      end

      it 'sets result as param1' do
        expect(action[:result]).to eq param1
      end

      it 'sets railway flow' do
        expect(action.railway_flow).to eq railway_flow
      end

      it 'sets pass_step as param2' do
        expect(action[:pass_step]).to eq param2
      end
    end

    describe 'conditional pass_way' do
      let(:action_block) { conditional_execution_for_pass }

      context 'when param2 present' do
        let(:railway_flow) { %i[model pass_step assign_result] }
        let(:param2) { 'params2' }

        it 'success' do
          expect(action).to be_success
        end

        it 'sets result as param1' do
          expect(action[:result]).to eq param1
        end

        it 'sets railway flow' do
          expect(action.railway_flow).to eq railway_flow
        end

        it 'sets pass_step as param2' do
          expect(action[:pass_step]).to eq param2
        end
      end

      context 'when param2 nil' do
        let(:railway_flow) { %i[model assign_result] }

        it 'success' do
          expect(action).to be_success
        end

        it 'sets result as param1' do
          expect(action[:result]).to eq param1
        end

        it 'sets railway flow' do
          expect(action.railway_flow).to eq railway_flow
        end

        it 'sets pass_step as param2' do
          expect(action[:pass_step]).to be_nil
        end
      end
    end
  end
end
