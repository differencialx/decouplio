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
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
