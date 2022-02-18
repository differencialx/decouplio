RSpec.describe 'Squad options validations' do
  include_context 'with basic spec setup'

  describe '.call' do
    context 'when not allowed option is provided for squad' do
      let(:action_block) { when_squad_other_options_not_allowed }

      message = "\033[1;33m Squad does not allow any options \033[0m"

      it_behaves_like 'raises option validation error',
                      message: message
    end
  end
end
