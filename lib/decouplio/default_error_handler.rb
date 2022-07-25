# frozen_string_literal: true

module Decouplio
  class DefaultErrorHandler
    attr_reader :errors, :status

    def initialize
      @errors = {}
      @status = nil
    end

    def add_error(*args)
      case args.size
      when 1
        args[0].each do |key, message|
          @errors.store(
            key,
            (@errors[key] || []) + [message].flatten
          )
        end
      when 2
        @errors.store(
          args[0],
          (@errors[args[0]] || []) + [args[1]].flatten
        )
      end
    end

    def error_status(err_st)
      @status = err_st
    end

    def merge(error_store)
      @errors = @errors.merge(error_store.errors) do |_key, this_val, other_val|
        this_val + other_val
      end
    end
  end
end
