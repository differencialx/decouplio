require_relative 'options_composer'

module Decouplio
  class LogicContainer
    attr_reader :steps, :squads
    attr_writer :steps

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
      @logic_container_raw_data.steps.each do |options|
        type = options.delete(:type)
        name = options.delete(:name)
        @steps << Decouplio::OptionsComposer.call(
          name: name,
          options: options,
          type: type,
          action_class: @action_class
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
