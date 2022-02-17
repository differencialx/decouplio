# frozen_string_literal: true

shared_examples 'raises option validation error' do |message:|
  it 'raises option validation error' do
    # binding.pry
    # action

    expect { action }.to raise_error Decouplio::Errors::OptionsValidationError, message
  end
end

shared_examples 'does not raise any error' do
  it 'does not raise any error' do
    # binding.pry
    expect { action }.not_to raise_error
  end
end
