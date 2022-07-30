RSpec.describe Decouplio::DefaultMetaStore do
  subject(:meta_store) { described_class.new }

  describe '#status' do
    it 'assigns status' do
      expect(meta_store.status).to be_nil
      meta_store.status = :some_status
      expect(meta_store.status).to eq :some_status
    end
  end

  describe '#add_error' do
    context 'when one error' do
      it 'add one error' do
        expect(meta_store.errors).to be_empty
        meta_store.add_error(:some_error, 'Message 1')
        expect(meta_store.errors).to eq(
          {
            some_error: ['Message 1']
          }
        )
      end
    end

    context 'when two errors' do
      it 'adds several errors' do
        expect(meta_store.errors).to be_empty
        meta_store.add_error(:some_error, ['Message 1', 'Message 2'])
        meta_store.add_error(:other_error, 'Message 3')
        expect(meta_store.errors).to eq(
          {
            some_error: ['Message 1', 'Message 2'],
            other_error: ['Message 3']
          }
        )
      end
    end
  end

  describe '#to_s' do
    let(:expected_string) do
      <<~METASTORE
        Status: #{expected_status}

        Errors:
          #{expected_errors}
      METASTORE
    end
    let(:expected_status) { 'NONE' }
    let(:expected_errors) { 'NONE' }

    context 'when status empty' do
      it 'returns proper string' do
        expect(meta_store.to_s).to eq expected_string
      end
    end

    context 'when status present' do
      let(:expected_status) { 'random_status' }

      before do
        meta_store.status = :random_status
      end

      it 'returns proper string' do
        expect(meta_store.to_s).to eq expected_string
      end
    end

    context 'when errors is present' do
      let(:expected_errors) do
        ":error_one => [\"Message 1\"]\n  "\
        ":error_two => [\"Message 2\"]"
      end

      before do
        meta_store.add_error(:error_one, 'Message 1')
        meta_store.add_error(:error_two, 'Message 2')
      end

      it 'returns proper string' do
        expect(meta_store.to_s).to eq expected_string
      end
    end

    context 'when errors is empty' do
      it 'returns proper string' do
        expect(meta_store.to_s).to eq expected_string
      end
    end
  end
end
