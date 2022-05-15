# frozen_string_literal: true

RSpec.describe 'Reserved method names' do
  include_context 'with basic spec setup'

  context 'when #[]' do
    let(:action_block) { when_method_brackets }

    message = format(
      Decouplio::Const::Validations::Common::STEP_NAME,
      :[]
    )

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::StepNameError,
                    message: message
  end

  context 'when #success?' do
    let(:action_block) { when_method_success? }

    message = format(
      Decouplio::Const::Validations::Common::STEP_NAME,
      :success?
    )

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::StepNameError,
                    message: message
  end

  context 'when #failure?' do
    let(:action_block) { when_method_failure? }

    message = format(
      Decouplio::Const::Validations::Common::STEP_NAME,
      :failure?
    )

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::StepNameError,
                    message: message
  end

  context 'when #fail_action' do
    let(:action_block) { when_method_fail_action }

    message = format(
      Decouplio::Const::Validations::Common::STEP_NAME,
      :fail_action
    )

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::StepNameError,
                    message: message
  end

  context 'when #pass_action' do
    let(:action_block) { when_method_pass_action }

    message = format(
      Decouplio::Const::Validations::Common::STEP_NAME,
      :pass_action
    )

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::StepNameError,
                    message: message
  end

  context 'when #append_railway_flow' do
    let(:action_block) { when_method_append_railway_flow }

    message = format(
      Decouplio::Const::Validations::Common::STEP_NAME,
      :append_railway_flow
    )

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::StepNameError,
                    message: message
  end

  context 'when #inspect' do
    let(:action_block) { when_method_inspect }

    message = format(
      Decouplio::Const::Validations::Common::STEP_NAME,
      :inspect
    )

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::StepNameError,
                    message: message
  end

  context 'when #to_s' do
    let(:action_block) { when_method_to_s }

    message = format(
      Decouplio::Const::Validations::Common::STEP_NAME,
      :to_s
    )

    it_behaves_like 'raises option validation error',
                    error_class: Decouplio::Errors::StepNameError,
                    message: message
  end
end
