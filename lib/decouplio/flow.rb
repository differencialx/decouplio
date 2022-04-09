# frozen_string_literal: true

require_relative 'logic_dsl'
require_relative 'composer'

module Decouplio
  class Flow
    def self.call(logic:, action_class:)
      logic_container_raw_data = Class.new(Decouplio::LogicDsl, &logic)
      Decouplio::Composer.compose(logic_container_raw_data: logic_container_raw_data)
    end
  end
end
