# frozen_string_literal: true

require_relative 'logic_dsl'
require_relative 'logic_composer'
require_relative 'logic_container'

module Decouplio
  class Flow
    def self.call(logic:, action_class:)
      logic_container_raw_data = Class.new(Decouplio::LogicDsl, &logic)
      logic_container = LogicContainer.new(
        logic_container_raw_data: logic_container_raw_data,
        action_class: action_class
      ).call
      Decouplio::LogicComposer.compose(logic_container: logic_container)
    end
  end
end
