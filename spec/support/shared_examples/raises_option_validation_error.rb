# frozen_string_literal: true

shared_examples 'raises option validation error' do |error_class:, message:|
  it 'raises option validation error' do
    expect { action }.to raise_proper_error(error_class, message)
  end
end

shared_examples 'does not raise any error' do
  it 'does not raise any error' do
    expect { action }.not_to raise_error
  end
end
