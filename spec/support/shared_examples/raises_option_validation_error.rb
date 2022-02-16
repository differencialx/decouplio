# frozen_string_literal: true

shared_examples 'raises option validation error' do |message:|
  it 'raises option validation error' do
    # binding.pry
    expect { action }.to raise Decouplio::Errors::OptionsValidationError, message
  end
end
