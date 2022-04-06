# frozen_string_literal: true

require_relative 'options_composer'
require_relative 'flow'

module Decouplio
  class LogicContainer
    attr_accessor :steps
    attr_reader :squads

    def initialize(logic_container_raw_data:, action_class:)
      @logic_container_raw_data = logic_container_raw_data
      @action_class = action_class
      @steps = []
      @squads = {}
    end

    def call
      process_steps
      process_squads
      self
    end

    private

    def process_steps
      step_names = @logic_container_raw_data.steps.map { |stp| [stp[:name], stp[:type]] }.to_h
      @logic_container_raw_data.steps.each do |options|
        type = options.delete(:type)
        name = options.delete(:name)
        wrap_inner_block = options.delete(:wrap_inner_block)
        wrap_inner_flow = nil
        if wrap_inner_block
          wrap_inner_flow = Flow.call(
            logic: wrap_inner_block,
            action_class: @action_class
          ).first
        end
        @steps << Decouplio::OptionsComposer.call(
          name: name,
          options: options,
          type: type,
          action_class: @action_class,
          step_names: step_names,
          wrap_inner_flow: wrap_inner_flow
        )[:options]
      end
    end

    def process_squads
      @logic_container_raw_data.squads.each do |squad_name, stp_instance|
        stp_instance.logic_container = self.class.new(
          logic_container_raw_data: stp_instance.steps,
          action_class: @action_class
        ).call
        @squads[squad_name] = stp_instance
      end
    end
  end
end
