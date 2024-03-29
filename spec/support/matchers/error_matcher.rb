# frozen_string_literal: true

RSpec::Matchers.define :raise_proper_error do |error_class, error_message|
  match do |actual|
    actual.call
    false
  rescue Decouplio::Errors::BaseError => e
    error_class_success = error_class == e.class

    return unless error_class_success

    error_message == e.message
  end

  failure_message do |actual|
    actual.call
    <<~MESSAGE
      #{error_class} error should've been raised
    MESSAGE
  rescue Decouplio::Errors::BaseError => e
    if error_class != e.class
      <<~MESSAGE
        expected:
        #{error_class}
        got:
        #{e.class}
      MESSAGE
    elsif error_message != e.message
      actual_array = e.message.split("\n")
      expected_array = error_message.split("\n")
      actual_array.each_with_index do |line, index|
        next if line == expected_array[index]

        return <<~MESSAGE
          expected:
            #{error_message}
          got:
            #{e.message}

          diff:
            expected: #{expected_array[index]}
            got:      #{line}
        MESSAGE
      end
    end
  end

  def supports_block_expectations?
    true
  end
end
