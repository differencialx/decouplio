# frozen_string_literal: true

require 'bundler/setup'
require 'decouplio'
require 'pry'

Dir[Dir.pwd + '/spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.include ResqCases
  config.include InnerActionCases
  config.include ResqInnerActionCases
  config.include WrapCases
  config.include FinishHimCases
  config.include OnSuccessFailureCases
  config.include RailwayCases
  config.include OctoCasesPalps
  config.include OptionsValidationsCasesForFail
  config.include OptionsValidationsCasesForPass
  config.include OptionsValidationsCasesForStep
  config.include OptionsValidationsCasesForOcto
  config.include OptionsValidationsCasesForResq
  config.include OptionsValidationsCasesForWrap
  config.include ReservedMethodNamesCases
  config.include ServiceCases
  config.include OctoMethodCases
  config.include OnErrorCases
  config.include FailAsAideCases
  config.include StepAsDobyCases
  config.include MetaStoreCases
  config.include ActionCases
  config.include OctoPalpOnSOnFCases
  config.include OctoAsStepCases
  config.example_status_persistence_file_path = '.rspec_status'

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
