class ErrorStore
  attr_reader :errors

  def initialize
    @errors = {}
  end

  def add_error(key:, message:)
    @errors.store(key, [message].flatten)
    puts 'pidor'
  end
end

class Default < Decouplio::Action
  step :one

  def one(**)
    add_error('pidor', 'lox')
  end
end


class One < Decouplio::Action
  error_store_instance ErrorStore.new
  step :one

  def one(**)
    add_error(key: :pidor, message: 'lox')
  end
end


class Two < One
  step :two

  def two(**)
    add_error(key: :pidor, message: 'pidor')
  end
end
