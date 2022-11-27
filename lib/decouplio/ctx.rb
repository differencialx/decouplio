# frozen_string_literal: true

module Decouplio
  class Ctx < Hash
    def method_missing(method_name, *_args)
      self[method_name] if key?(method_name)
    end

    def respond_to_missing?(method_name, include_private = false)
      key?(method_name) || super
    end
  end
end
