# frozen_string_literal: true

module Decouplio
  class DefaultErrorHandler
    attr_reader :errors

    def initialize
      @errors = {}
    end

    def add_error(key, message)
      @errors.store(
        key,
        (@errors[key] || []) + [message].flatten
      )
    end

    def merge(error_store)
      @errors = @errors.merge(error_store.errors) do |_key, this_val, other_val|
        this_val + other_val
      end
    end
  end
end
