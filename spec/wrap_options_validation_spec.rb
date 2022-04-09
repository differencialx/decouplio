# # frozen_string_literal: true

# RSpec.describe 'Wrap options validations' do
#   include_context 'with basic spec setup'

#   describe '.call' do
#     xcontext 'when wrap on_success step method is not defined' do
#       let(:action_block) { when_wrap_on_success_method_not_defined }

#       interpolation_values = [
#         Decouplio::OptionsValidator::YELLOW,
#         '{:on_success=>:step_two}',
#         'Method "step_two" is not defined',
#         Decouplio::OptionsValidator::WRAP_ALLOWED_OPTIONS_MESSAGE,
#         Decouplio::OptionsValidator::WRAP_MANUAL_URL,
#         Decouplio::OptionsValidator::NO_COLOR
#       ]

#       message = Decouplio::OptionsValidator::WRAP_VALIDATION_ERROR_MESSAGE % interpolation_values

#       it_behaves_like 'raises option validation error',
#                       message: message
#     end

#     xcontext 'when wrap on_failure step method is not defined' do
#       let(:action_block) { when_wrap_on_falire_method_not_defined }

#       interpolation_values = [
#         Decouplio::OptionsValidator::YELLOW,
#         '{:on_failure=>:step_two}',
#         'Method "step_two" is not defined',
#         Decouplio::OptionsValidator::WRAP_ALLOWED_OPTIONS_MESSAGE,
#         Decouplio::OptionsValidator::WRAP_MANUAL_URL,
#         Decouplio::OptionsValidator::NO_COLOR
#       ]
#       message = Decouplio::OptionsValidator::WRAP_VALIDATION_ERROR_MESSAGE % interpolation_values

#       it_behaves_like 'raises option validation error',
#                       message: message
#     end

#     context 'when wrap on_success step is not defined' do
#       let(:action_block) { when_wrap_on_success_step_not_defined }

#       interpolation_values = [
#         Decouplio::OptionsValidator::YELLOW,
#         '{:on_success=>:step_two}',
#         'Step "step_two" is not defined',
#         Decouplio::OptionsValidator::WRAP_ALLOWED_OPTIONS_MESSAGE,
#         Decouplio::OptionsValidator::WRAP_MANUAL_URL,
#         Decouplio::OptionsValidator::NO_COLOR
#       ]

#       message = Decouplio::OptionsValidator::WRAP_VALIDATION_ERROR_MESSAGE % interpolation_values

#       it_behaves_like 'raises option validation error',
#                       message: message
#     end

#     context 'when wrap on_failure step is not defined' do
#       let(:action_block) { when_wrap_on_failure_step_not_defined }

#       interpolation_values = [
#         Decouplio::OptionsValidator::YELLOW,
#         '{:on_failure=>:step_two}',
#         'Step "step_two" is not defined',
#         Decouplio::OptionsValidator::WRAP_ALLOWED_OPTIONS_MESSAGE,
#         Decouplio::OptionsValidator::WRAP_MANUAL_URL,
#         Decouplio::OptionsValidator::NO_COLOR
#       ]

#       message = Decouplio::OptionsValidator::WRAP_VALIDATION_ERROR_MESSAGE % interpolation_values

#       it_behaves_like 'raises option validation error',
#                       message: message
#     end

#     context 'when wrap finish_him is not a boolean' do
#       let(:action_block) { when_wrap_finish_him_is_not_a_boolean }

#       interpolation_values = [
#         Decouplio::OptionsValidator::YELLOW,
#         '{:finish_him=>123}',
#         '"finish_him" does not allow "123" value',
#         Decouplio::OptionsValidator::WRAP_ALLOWED_OPTIONS_MESSAGE,
#         Decouplio::OptionsValidator::WRAP_MANUAL_URL,
#         Decouplio::OptionsValidator::NO_COLOR
#       ]
#       message = Decouplio::OptionsValidator::WRAP_VALIDATION_ERROR_MESSAGE % interpolation_values

#       it_behaves_like 'raises option validation error',
#                       message: message
#     end

#     context 'when wrap finish_him is a boolean' do
#       let(:action_block) { when_wrap_finish_him_is_a_boolean }

#       interpolation_values = [
#         Decouplio::OptionsValidator::YELLOW,
#         '{:finish_him=>true}',
#         '"finish_him" does not allow "true" value',
#         Decouplio::OptionsValidator::WRAP_ALLOWED_OPTIONS_MESSAGE,
#         Decouplio::OptionsValidator::WRAP_MANUAL_URL,
#         Decouplio::OptionsValidator::NO_COLOR
#       ]
#       message = Decouplio::OptionsValidator::WRAP_VALIDATION_ERROR_MESSAGE % interpolation_values

#       it_behaves_like 'raises option validation error',
#                       message: message
#     end

#     context 'when wrap finish_him is not :on_success nor :on_failure' do
#       let(:action_block) { when_wrap_finish_him_is_not_a_on_success_or_on_failure_symbol }

#       interpolation_values = [
#         Decouplio::OptionsValidator::YELLOW,
#         '{:finish_him=>:some_option}',
#         '"finish_him" does not allow "some_option" value',
#         Decouplio::OptionsValidator::WRAP_ALLOWED_OPTIONS_MESSAGE,
#         Decouplio::OptionsValidator::WRAP_MANUAL_URL,
#         Decouplio::OptionsValidator::NO_COLOR
#       ]
#       message = Decouplio::OptionsValidator::WRAP_VALIDATION_ERROR_MESSAGE % interpolation_values

#       it_behaves_like 'raises option validation error',
#                       message: message
#     end

#     context 'when not allowed option is provided for wrap' do
#       let(:action_block) { when_wrap_not_allowed_option_provided }

#       interpolation_values = [
#         Decouplio::OptionsValidator::YELLOW,
#         '{:not_allowed_option=>:some_option}',
#         'Please check if wrap option is allowed',
#         Decouplio::OptionsValidator::WRAP_ALLOWED_OPTIONS_MESSAGE,
#         Decouplio::OptionsValidator::WRAP_MANUAL_URL,
#         Decouplio::OptionsValidator::NO_COLOR
#       ]
#       message = Decouplio::OptionsValidator::WRAP_VALIDATION_ERROR_MESSAGE % interpolation_values

#       it_behaves_like 'raises option validation error',
#                       message: message
#     end

#     xcontext 'when if method is not defined for wrap' do
#       let(:action_block) { when_wrap_if_method_is_not_defined }

#       interpolation_values = [
#         Decouplio::OptionsValidator::YELLOW,
#         '{:if=>:some_undefined_method}',
#         'Method "some_undefined_method" is not defined',
#         Decouplio::OptionsValidator::WRAP_ALLOWED_OPTIONS_MESSAGE,
#         Decouplio::OptionsValidator::WRAP_MANUAL_URL,
#         Decouplio::OptionsValidator::NO_COLOR
#       ]
#       message = Decouplio::OptionsValidator::WRAP_VALIDATION_ERROR_MESSAGE % interpolation_values

#       it_behaves_like 'raises option validation error',
#                       message: message
#     end

#     xcontext 'when unless method is not defined for wrap' do
#       let(:action_block) { when_wrap_unless_method_is_not_defined }

#       interpolation_values = [
#         Decouplio::OptionsValidator::YELLOW,
#         '{:unless=>:some_undefined_method}',
#         'Method "some_undefined_method" is not defined',
#         Decouplio::OptionsValidator::WRAP_ALLOWED_OPTIONS_MESSAGE,
#         Decouplio::OptionsValidator::WRAP_MANUAL_URL,
#         Decouplio::OptionsValidator::NO_COLOR
#       ]
#       message = Decouplio::OptionsValidator::WRAP_VALIDATION_ERROR_MESSAGE % interpolation_values

#       it_behaves_like 'raises option validation error',
#                       message: message
#     end

#     xcontext 'when wrap klass method is not defined' do
#       let(:action_block) { when_wrap_klass_method_not_defined }

#       interpolation_values = [
#         Decouplio::OptionsValidator::YELLOW,
#         '{:klass=>ClassWithWrapperMethod, :method=>:turonsakteon}',
#         'Method "turonsakteon" is not defined for "ClassWithWrapperMethod" class',
#         Decouplio::OptionsValidator::WRAP_ALLOWED_OPTIONS_MESSAGE,
#         Decouplio::OptionsValidator::WRAP_MANUAL_URL,
#         Decouplio::OptionsValidator::NO_COLOR
#       ]
#       message = Decouplio::OptionsValidator::WRAP_VALIDATION_ERROR_MESSAGE % interpolation_values

#       it_behaves_like 'raises option validation error',
#                       message: message
#     end

#     context 'when wrap klass is present and method was not passed' do
#       let(:action_block) { when_wrap_klass_is_present_and_method_was_not_passed }

#       interpolation_values = [
#         Decouplio::OptionsValidator::YELLOW,
#         '{:klass=>ClassWithWrapperMethod}',
#         '"klass" options should be passed along with "method" option',
#         Decouplio::OptionsValidator::WRAP_ALLOWED_OPTIONS_MESSAGE,
#         Decouplio::OptionsValidator::WRAP_MANUAL_URL,
#         Decouplio::OptionsValidator::NO_COLOR
#       ]
#       message = Decouplio::OptionsValidator::WRAP_VALIDATION_ERROR_MESSAGE % interpolation_values

#       it_behaves_like 'raises option validation error',
#                       message: message
#     end

#     context 'when wrap method is present and klass was not passed' do
#       let(:action_block) { when_wrap_method_is_present_and_klass_was_not_passed }

#       interpolation_values = [
#         Decouplio::OptionsValidator::YELLOW,
#         '{:method=>:turonsakteon}',
#         '"klass" options should be passed along with "method" option',
#         Decouplio::OptionsValidator::WRAP_ALLOWED_OPTIONS_MESSAGE,
#         Decouplio::OptionsValidator::WRAP_MANUAL_URL,
#         Decouplio::OptionsValidator::NO_COLOR
#       ]
#       message = Decouplio::OptionsValidator::WRAP_VALIDATION_ERROR_MESSAGE % interpolation_values

#       it_behaves_like 'raises option validation error',
#                       message: message
#     end

#     context 'when wrap name is not specified' do
#       let(:action_block) { when_wrap_name_is_not_specified }

#       interpolation_values = [
#         Decouplio::OptionsValidator::YELLOW,
#         'wrap name is empty',
#         'Please specify name for "wrap"',
#         Decouplio::OptionsValidator::WRAP_ALLOWED_OPTIONS_MESSAGE,
#         Decouplio::OptionsValidator::WRAP_MANUAL_URL,
#         Decouplio::OptionsValidator::NO_COLOR
#       ]
#       message = Decouplio::OptionsValidator::WRAP_VALIDATION_ERROR_MESSAGE % interpolation_values

#       it_behaves_like 'raises option validation error',
#                       message: message
#     end
#   end
# end
