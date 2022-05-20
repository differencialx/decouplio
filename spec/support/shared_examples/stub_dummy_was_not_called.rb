# frozen_string_literal: true

shared_examples 'stub dummy was not called' do
  it 'stub dummy was not called' do
    action
    expect(StubDummy).not_to have_received(:call)
  end
end
