module Decouplio
  class DefaultErrorHandler
    attr_reader :errors

    def initialize
      @errors = {}
    end

    def add_error(key, message)
      @errors.store(key, [message].flatten)
      puts 'default'
    end
  end
end
