# frozen_string_literal: true

class ThreadSafeAction < Decouplio::Action
  logic do
    step :concat
    step :substract
    step :multiply
    step :divide
    step :result
  end

  def concat(concat:, **)
    ctx[:result] = concat + concat
  end

  def substract(substract:, result:, **)
    ctx[:result] = result - substract
  end

  def multiply(multiply:, result:, **)
    ctx[:result] = result * multiply
  end

  def divide(divide:, result:, **)
    ctx[:result] = result / divide
  end

  def result(result:, **)
    ctx[:result] = result.to_s
  end
end

RSpec.describe 'Thread safety' do
  let(:threads) do
    threads = {}
    threads[:one] = Thread.new do
      ThreadSafeAction.call(
        concat: 1,
        substract: 1,
        multiply: 10,
        divide: 5
      ) # => 2
    end
    threads[:two] = Thread.new do
      ThreadSafeAction.call(
        concat: 2,
        substract: 1,
        multiply: 10,
        divide: 5
      ) # => 6
    end
    threads[:three] = Thread.new do
      ThreadSafeAction.call(
        concat: 3,
        substract: 1,
        multiply: 10,
        divide: 5
      ) # => 10
    end
    threads[:four] = Thread.new do
      ThreadSafeAction.call(
        concat: 4,
        substract: 1,
        multiply: 10,
        divide: 5
      ) # => 14
    end
    threads[:five] = Thread.new do
      ThreadSafeAction.call(
        concat: 5,
        substract: 1,
        multiply: 10,
        divide: 5
      ) # => 18
    end
    threads[:six] = Thread.new do
      ThreadSafeAction.call(
        concat: 6,
        substract: 1,
        multiply: 10,
        divide: 5
      ) # => 22
    end
    threads[:seven] = Thread.new do
      ThreadSafeAction.call(
        concat: 7,
        substract: 1,
        multiply: 10,
        divide: 5
      ) # => 26
    end
    threads[:eight] = Thread.new do
      ThreadSafeAction.call(
        concat: 8,
        substract: 1,
        multiply: 10,
        divide: 5
      ) # => 30
    end
    threads[:nine] = Thread.new do
      ThreadSafeAction.call(
        concat: 9,
        substract: 1,
        multiply: 10,
        divide: 5
      ) # => 34
    end
    threads[:ten] = Thread.new do
      ThreadSafeAction.call(
        concat: 10,
        substract: 1,
        multiply: 10,
        divide: 5
      ) # => 38
    end

    threads
  end

  it 'returns correct value' do
    threads.values.each(&:join)

    expect(threads[:one].value[:result]).to eq '2'
    expect(threads[:two].value[:result]).to eq '6'
    expect(threads[:three].value[:result]).to eq '10'
    expect(threads[:four].value[:result]).to eq '14'
    expect(threads[:five].value[:result]).to eq '18'
    expect(threads[:six].value[:result]).to eq '22'
    expect(threads[:seven].value[:result]).to eq '26'
    expect(threads[:eight].value[:result]).to eq '30'
    expect(threads[:nine].value[:result]).to eq '34'
    expect(threads[:ten].value[:result]).to eq '38'
  end
end
