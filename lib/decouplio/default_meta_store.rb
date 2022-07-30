module Decouplio
  class DefaultMetaStore
    attr_accessor :status
    attr_reader :errors

    def initialize
      @errors = {}
      @status = nil
    end

    def add_error(key, messages)
      @errors.store(
        key,
        (@errors[key] || []) + [messages].flatten
      )
    end

    def to_s
      <<~METASTORE
        Status: #{@status || 'NONE'}

        Errors:
          #{errors_string}
      METASTORE
    end

    private

    def errors_string
      return 'NONE' if @errors.empty?

      @errors.map do |k, v|
        "#{k.inspect} => #{v.inspect}"
      end.join("\n  ")
    end
  end
end
