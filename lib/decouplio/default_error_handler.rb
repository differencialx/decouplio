# frozen_string_literal: true

module Decouplio
  class DefaultErrorHandler
    attr_reader :errors

    def initialize
      @errors = {}
    end

    def add_error(key, message)
      @errors.store(key, [message].flatten)
    end
  end
end
