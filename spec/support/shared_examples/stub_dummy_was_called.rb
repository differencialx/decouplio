# frozen_string_literal: true

shared_examples 'stub dummy was called' do
  it 'calls stub dummy' do
    action
    expect(StubDummy).to have_received(:call)
  end
end
