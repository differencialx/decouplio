# frozen_string_literal: true

require 'bundler/setup'
require 'decouplio'
require 'pry'

Dir[Dir.pwd + '/spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.include AfterBlockCases
  config.include GendalfCases
  config.include StepCases
  config.include RescueForCases
  config.include InnerActionCases
  config.include ValidationCases
  config.include WrapperCases
  config.include FinishHimCases
  config.include OnFailureCases
  config.include TagsCases
  config.include PrepareParamsCases
  config.example_status_persistence_file_path = '.rspec_status'

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
