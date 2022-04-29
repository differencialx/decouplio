# frozen_string_literal: true

shared_examples 'check action state' do
  it 'has proper state' do
    expect(action).to have_a_state(expected_state)
  end
end
