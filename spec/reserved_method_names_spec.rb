# frozen_string_literal: true

RSpec.describe 'Reserved method names' do
  include_context 'with basic spec setup'

  describe '[]' do
    context 'when #step_brackets' do
      let(:action_block) { when_method_step_brackets }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :[]
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #fail_brackets' do
      let(:action_block) { when_method_fail_brackets }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :[]
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #pass_brackets' do
      let(:action_block) { when_method_pass_brackets }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :[]
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #octo_brackets' do
      let(:action_block) { when_method_octo_brackets }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :[]
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #wrap_brackets' do
      let(:action_block) { when_method_wrap_brackets }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :[]
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #resq_general_brackets' do
      let(:action_block) { when_method_resq_general_brackets }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :[]
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #resq_mappings_brackets' do
      let(:action_block) { when_method_resq_mapping_brackets }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :[]
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when if_brackets' do
      let(:action_block) { when_method_if_brackets }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :[]
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when unless_brackets' do
      let(:action_block) { when_method_unless_brackets }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :[]
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end
  end

  describe 'inspect' do
    context 'when #step_inspect' do
      let(:action_block) { when_method_step_inspect }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :inspect
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #fail_inspect' do
      let(:action_block) { when_method_fail_inspect }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :inspect
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #pass_inspect' do
      let(:action_block) { when_method_pass_inspect }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :inspect
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #octo_inspect' do
      let(:action_block) { when_method_octo_inspect }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :inspect
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #wrap_inspect' do
      let(:action_block) { when_method_wrap_inspect }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :inspect
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #resq_general_inspect' do
      let(:action_block) { when_method_resq_general_inspect }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :inspect
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #resq_mappings_inspect' do
      let(:action_block) { when_method_resq_mapping_inspect }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :inspect
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when if_inspect' do
      let(:action_block) { when_method_if_inspect }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :inspect
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when unless_inspect' do
      let(:action_block) { when_method_unless_inspect }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :inspect
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end
  end

  describe 'to_s' do
    context 'when #step_to_s' do
      let(:action_block) { when_method_step_to_s }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :to_s
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #fail_to_s' do
      let(:action_block) { when_method_fail_to_s }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :to_s
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #pass_to_s' do
      let(:action_block) { when_method_pass_to_s }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :to_s
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #octo_to_s' do
      let(:action_block) { when_method_octo_to_s }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :to_s
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #wrap_to_s' do
      let(:action_block) { when_method_wrap_to_s }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :to_s
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #resq_general_to_s' do
      let(:action_block) { when_method_resq_general_to_s }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :to_s
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #resq_mappings_to_s' do
      let(:action_block) { when_method_resq_mapping_to_s }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :to_s
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when if_to_s' do
      let(:action_block) { when_method_if_to_s }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :to_s
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when unless_to_s' do
      let(:action_block) { when_method_unless_to_s }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :to_s
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end
  end

  describe 'PASS' do
    context 'when #step_pass' do
      let(:action_block) { when_method_step_pass }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :PASS
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #fail_pass' do
      let(:action_block) { when_method_fail_pass }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :PASS
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #pass_pass' do
      let(:action_block) { when_method_pass_pass }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :PASS
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #octo_pass' do
      let(:action_block) { when_method_octo_pass }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :PASS
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #wrap_pass' do
      let(:action_block) { when_method_wrap_pass }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :PASS
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #resq_general_pass' do
      let(:action_block) { when_method_resq_general_pass }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :PASS
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #resq_mappings_pass' do
      let(:action_block) { when_method_resq_mapping_pass }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :PASS
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when if_pass' do
      let(:action_block) { when_method_if_pass }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :PASS
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when unless_pass' do
      let(:action_block) { when_method_unless_pass }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :PASS
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end
  end

  describe 'FAIL' do
    context 'when #step_fail' do
      let(:action_block) { when_method_step_fail }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :FAIL
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #fail_fail' do
      let(:action_block) { when_method_fail_fail }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :FAIL
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #pass_fail' do
      let(:action_block) { when_method_pass_fail }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :FAIL
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #octo_fail' do
      let(:action_block) { when_method_octo_fail }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :FAIL
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #wrap_fail' do
      let(:action_block) { when_method_wrap_fail }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :FAIL
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #resq_general_fail' do
      let(:action_block) { when_method_resq_general_fail }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :FAIL
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when #resq_mappings_fail' do
      let(:action_block) { when_method_resq_mapping_fail }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :FAIL
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when if_fail' do
      let(:action_block) { when_method_if_fail }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :FAIL
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end

    context 'when unless_fail' do
      let(:action_block) { when_method_unless_fail }

      message = format(
        Decouplio::Const::Validations::Common::STEP_NAME,
        :FAIL
      )

      it_behaves_like 'raises option validation error',
                      error_class: Decouplio::Errors::StepNameError,
                      message: message
    end
  end
end
