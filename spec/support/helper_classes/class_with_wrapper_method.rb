# frozen_string_literal: true

class ClassWithWrapperMethod
  def self.transaction(&block)
    block.call
  end
end
