# frozen_string_literal: true

class ClassWithWrapperMethod
  def self.transaction(&block)
    BeforeTransactionAction.call
    block.call
    AfterTransactionAction.call
  end
end
