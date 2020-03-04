# frozen_string_literal: true

module Decouplio
  class Gendalf
    attr_reader :klass, :options
    def initialize(klass)
      @klass = klass
    end
  end
end
