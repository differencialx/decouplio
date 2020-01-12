# frozen_string_literal: true

shared_examples 'fails with error' do
  it 'fails' do
    expect(action).to be_failure
  end

  it 'sets errors' do
    expect(action.errors).not_to be_empty
  end

  it 'errors should match to expected errors' do
    expect(action.errors).to match expected_errors
  end
end
