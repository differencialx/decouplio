RSpec.describe 'Step options validations' do
  include_context 'with basic spec setup'

  # xdescribe '.call' do
  #   xcontext 'when on_success step is not defined' do
  #     let(:action_block) { when_step_on_success_step_not_defined }

  #     interpolation_values = [
  #       'on_success: :step_two',
  #       'Method :step_two is not defined',
  #       Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
  #       Decouplio::OptionsValidator::STEP_MANUAL_URL
  #     ]
  #     message = Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values

  #     it_behaves_like 'raises option validation error',
  #                     message: message
  #   end

  #   xcontext 'when on_failure step is not defined' do
  #     let(:action_block) { when_step_on_failure_step_not_defined }

  #     interpolation_values = [
  #       'on_failure: :step_two',
  #       'Method :step_two is not defined',
  #       Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
  #       Decouplio::OptionsValidator::STEP_MANUAL_URL
  #     ]
  #     message = Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values

  #     it_behaves_like 'raises option validation error',
  #                     message: message
  #   end

  #   context 'when step finish_him is not a boolean' do
  #     let(:action_block) { when_step_on_failure_step_not_defined }

  #     interpolation_values = [
  #       'finish_him: 123',
  #       '"finish_him" does not allow  --> 123 <-- value',
  #       Decouplio::OptionsValidator::STEP_ALLOWED_OPTIONS_MESSAGE,
  #       Decouplio::OptionsValidator::STEP_MANUAL_URL
  #     ]
  #     message = Decouplio::OptionsValidator::STEP_VALIDATION_ERROR_MESSAGE % interpolation_values

  #     it_behaves_like 'raises option validation error',
  #                     message: message
  #   end
  # end
end
