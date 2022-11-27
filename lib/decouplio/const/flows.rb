# frozen_string_literal: true

module Decouplio
  module Const
    module Flows
      MAIN_FLOW = [
        Decouplio::Steps::Step,
        Decouplio::Steps::Fail,
        Decouplio::Steps::Pass,
        Decouplio::Steps::InnerActionStep,
        Decouplio::Steps::InnerActionFail,
        Decouplio::Steps::InnerActionPass,
        Decouplio::Steps::OctoByKey,
        Decouplio::Steps::OctoByMethod,
        Decouplio::Steps::ServiceAsStep,
        Decouplio::Steps::ServiceAsFail,
        Decouplio::Steps::ServiceAsPass,
        Decouplio::Steps::ServiceAsPass,
        Decouplio::Steps::WrapWithClass,
        Decouplio::Steps::WrapWithClassMethod,
        Decouplio::Steps::Wrap
      ].freeze
      PASS_FLOW = [
        Decouplio::Steps::Step,
        Decouplio::Steps::Pass,
        Decouplio::Steps::InnerActionStep,
        Decouplio::Steps::InnerActionPass,
        Decouplio::Steps::ServiceAsStep,
        Decouplio::Steps::ServiceAsPass,
        Decouplio::Steps::ServiceAsPass,
        Decouplio::Steps::OctoByKey,
        Decouplio::Steps::OctoByMethod,
        Decouplio::Steps::WrapWithClass,
        Decouplio::Steps::WrapWithClassMethod,
        Decouplio::Steps::Wrap
      ].freeze
      FAIL_FLOW = [
        Decouplio::Steps::Fail,
        Decouplio::Steps::InnerActionFail,
        Decouplio::Steps::ServiceAsFail
      ].freeze
      RESQ_CLASSES = [
        Decouplio::Steps::ResqPass,
        Decouplio::Steps::ResqFail,
        Decouplio::Steps::ResqWithMappingPass,
        Decouplio::Steps::ResqWithMappingFail
      ].freeze
      WRAP_CLASSES = [
        Decouplio::Steps::WrapWithClass,
        Decouplio::Steps::WrapWithClassMethod,
        Decouplio::Steps::Wrap
      ].freeze
      OCTO_CLASSES = [
        Decouplio::Steps::OctoByMethod,
        Decouplio::Steps::OctoByKey
      ].freeze
    end
  end
end
