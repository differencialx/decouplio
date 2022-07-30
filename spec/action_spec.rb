RSpec.describe Decouplio::Action do
  include_context 'with basic spec setup'

  describe 'action methods' do
    let(:action_block) { when_simple_action }

    it { expect(action).to respond_to(:ms) }
    it { expect(action).to respond_to(:meta_store) }
    it { expect(action).to respond_to(:railway_flow) }
    it { expect(action).to respond_to(:ctx) }
    it { expect(action).to respond_to(:success?) }
    it { expect(action).to respond_to(:failure?) }
    it { expect(action).to respond_to(:fail_action) }
    it { expect(action).to respond_to(:pass_action) }
    it { expect(action).to respond_to(:append_railway_flow) }
    it { expect(action).to respond_to(:to_s) }
    it { expect(action).to respond_to(:inspect) }
    it { expect(action.meta_store).to be_a(Decouplio::DefaultMetaStore) }
    it { expect(action.ms).to be_a(Decouplio::DefaultMetaStore) }
    it { expect(action.railway_flow).to be_a(Array) }
    it { expect(action.ctx).to be_a(Hash) }
  end
end
