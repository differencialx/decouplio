# frozen_string_literal: true

RSpec::Matchers.define :have_a_state do |state_hash|
  match do |actual|
    state_matches?(state_hash[:state]) &&
      outcome_matches?(state_hash[:action_status]) &&
      railway_matches?(state_hash[:railway_flow]) &&
      error_matches?(state_hash[:errors])
  end

  failure_message do |actual|
    unless outcome_matches?(state_hash[:action_status])
      return <<~MESSAGE
        Wrong action status:
          expected: #{state_hash[:action_status]}
          got:      #{actual.failure? ? :failure : :success}
      MESSAGE
    end

    unless railway_matches?(state_hash[:railway_flow])
      return <<~MESSAGE
        Railway flow does not match:
          expected: #{state_hash[:railway_flow]}
          got:      #{action.railway_flow}
      MESSAGE
    end

    unless state_matches?(state_hash[:state])
      got_hash = actual.ctx.slice(*state_hash[:state].keys)
      diff = state_hash[:state].to_h do |key, value|
        [
          key,
          { expected: value, got: got_hash[key] }
        ]
      end
      diff = diff.reject do |_key, diff_hash|
        diff_hash[:expected] == diff_hash[:got]
      end
      return <<~MESSAGE
        Context keys does not match:
        #{diff_message(diff)}
      MESSAGE
    end

    unless error_matches?(state_hash[:errors])
      <<~MESSAGE
        Errors does not match:
          expected: #{state_hash[:errors]}
          got:      #{actual.ms.errors}
      MESSAGE
    end
  end

  def diff_message(diff)
    diff.map do |key, diff_hash|
      <<~MESSAGE
        For ctx[:#{key}]
          expected: #{diff_hash[:expected].inspect}
          got:      #{diff_hash[:got].inspect}
      MESSAGE
    end.join("\n")
  end

  def state_matches?(state_hash)
    state_hash.all? do |key, value|
      actual[key] == value
    end
  end

  def outcome_matches?(action_status)
    actual.send("#{action_status}?")
  end

  def railway_matches?(railway_flow)
    actual.railway_flow == railway_flow
  end

  def error_matches?(errors)
    actual.ms.errors == errors
  end
end
