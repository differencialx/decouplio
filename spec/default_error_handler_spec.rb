# frozen_string_literal: true

RSpec.describe Decouplio::DefaultErrorHandler do
  describe '#add_error' do
    subject(:error_store) { described_class.new }

    context 'when array as input' do
      it 'returns correct errors hash' do
        expect(error_store.errors).to be_empty

        error_store.add_error({ some_error: ['Message One'] })
        expect(error_store.errors).to eq(
          {
            some_error: ['Message One']
          }
        )

        error_store.add_error(
          {
            another_error: ['Message Two', 'Message Three'],
            some_error: 'New message'
          }
        )
        expect(error_store.errors).to eq(
          {
            some_error: ['Message One', 'New message'],
            another_error: ['Message Two', 'Message Three']
          }
        )

        error_store.add_error(
          {
            email: ['Blank'],
            password: 'Blank'
          }
        )
        expect(error_store.errors).to eq(
          {
            some_error: ['Message One', 'New message'],
            another_error: ['Message Two', 'Message Three'],
            email: ['Blank'],
            password: ['Blank']
          }
        )
      end
    end

    context 'when error_key and message as input' do
      it 'returns correct errors hash' do
        expect(error_store.errors).to be_empty

        error_store.add_error(:some_error, 'Message One')
        expect(error_store.errors).to eq(
          {
            some_error: ['Message One']
          }
        )

        error_store.add_error(:another_error, ['Message Two', 'Message Three'])
        expect(error_store.errors).to eq(
          {
            some_error: ['Message One'],
            another_error: ['Message Two', 'Message Three']
          }
        )

        error_store.add_error(:some_error, 'Message Four')
        expect(error_store.errors).to eq(
          {
            some_error: ['Message One', 'Message Four'],
            another_error: ['Message Two', 'Message Three']
          }
        )
      end
    end
  end

  describe '#merge' do
    let(:first_error_store) { described_class.new }
    let(:second_error_store) { described_class.new }

    context 'when keys are the same' do
      before do
        first_error_store.add_error(:some_error, 'Message First')
        second_error_store.add_error(:some_error, 'Message Second')
      end

      it 'makes correct merge' do
        expect(first_error_store.errors).to eq(
          {
            some_error: ['Message First']
          }
        )
        expect(second_error_store.errors).to eq(
          {
            some_error: ['Message Second']
          }
        )

        first_error_store.merge(second_error_store)

        expect(first_error_store.errors).to eq(
          {
            some_error: ['Message First', 'Message Second']
          }
        )
        expect(second_error_store.errors).to eq(
          {
            some_error: ['Message Second']
          }
        )
      end
    end

    context 'when keys are different' do
      before do
        first_error_store.add_error(:some_error, 'Message First')
        second_error_store.add_error(:anothre_error, 'Message Second')
      end

      it 'makes correct merge' do
        expect(first_error_store.errors).to eq(
          {
            some_error: ['Message First']
          }
        )
        expect(second_error_store.errors).to eq(
          {
            anothre_error: ['Message Second']
          }
        )

        first_error_store.merge(second_error_store)

        expect(first_error_store.errors).to eq(
          {
            some_error: ['Message First'],
            anothre_error: ['Message Second']
          }
        )
        expect(second_error_store.errors).to eq(
          {
            anothre_error: ['Message Second']
          }
        )
      end
    end
  end

  describe '#error_status' do
    subject(:error_store) { described_class.new }

    it 'sets error status' do
      expect(error_store.status).to be_nil

      error_store.error_status(:not_found)

      expect(error_store.status).to eq :not_found
    end
  end
end
