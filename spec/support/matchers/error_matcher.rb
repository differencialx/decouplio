# frozen_string_literal: true

RSpec::Matchers.define :raise_proper_error do |error_class, error_message|
  match do |actual|
    actual.call
  rescue StandardError => e
    error_class == e.class
    error_message == e.message
  end

  failure_message do |actual|
    actual.call

  rescue StandardError => e
    if error_class != e.class
      <<~MESSAGE
        expected: #{error_class}
        got:      #{e.class}
      MESSAGE
    elsif error_message != e.message
      actual_array = e.message.split("\n")
      expected_array = error_message.split("\n")
      actual_array.each_with_index do |line, index|
        next if line == expected_array[index]

        return <<~MESSAGE
          expected: #{error_message}
          got:      #{e.message}

          diff:
            expected: #{line}
            got:      #{expected_array[index]}
        MESSAGE
      end
    end
  end

  def supports_block_expectations?
    true
  end
end
