# frozen_string_literal: true

module Decouplio
  module Const
    module Types
      STEP_TYPE = :step
      FAIL_TYPE = :fail
      PASS_TYPE = :pass
      IF_TYPE = :if
      UNLESS_TYPE = :unless
      IF_TYPE_PASS = :if_pass
      UNLESS_TYPE_PASS = :unless_pass
      IF_TYPE_FAIL = :if_fail
      UNLESS_TYPE_FAIL = :unless_fail
      OCTO_TYPE = :octo
      DOBY_TYPE = :doby
      AIDE_TYPE = :aide
      ACTION_TYPE_STEP = :action_step
      ACTION_TYPE_FAIL = :action_fail
      ACTION_TYPE_PASS = :action_pass
      SERVICE_TYPE_STEP = :service_step
      SERVICE_TYPE_FAIL = :service_fail
      SERVICE_TYPE_PASS = :service_pass
      WRAP_TYPE = :wrap
      RESQ_TYPE = :resq
      RESQ_TYPE_STEP = :resq_step
      RESQ_TYPE_FAIL = :resq_fail
      RESQ_TYPE_PASS = :resq_pass
      STEP_TYPE_TO_CONDITION_TYPE = {
        STEP_TYPE => {
          IF_TYPE => IF_TYPE_PASS,
          UNLESS_TYPE => UNLESS_TYPE_PASS
        },
        FAIL_TYPE => {
          IF_TYPE => IF_TYPE_FAIL,
          UNLESS_TYPE => UNLESS_TYPE_FAIL
        },
        PASS_TYPE => {
          IF_TYPE => IF_TYPE_PASS,
          UNLESS_TYPE => UNLESS_TYPE_PASS
        },
        OCTO_TYPE => {
          IF_TYPE => IF_TYPE_PASS,
          UNLESS_TYPE => UNLESS_TYPE_PASS
        },
        WRAP_TYPE => {
          IF_TYPE => IF_TYPE_PASS,
          UNLESS_TYPE => UNLESS_TYPE_PASS
        },
        RESQ_TYPE_STEP => {
          IF_TYPE => IF_TYPE_PASS,
          UNLESS_TYPE => UNLESS_TYPE_PASS
        },
        RESQ_TYPE_FAIL => {
          IF_TYPE => IF_TYPE_FAIL,
          UNLESS_TYPE => UNLESS_TYPE_FAIL
        },
        RESQ_TYPE_PASS => {
          IF_TYPE => IF_TYPE_PASS,
          UNLESS_TYPE => UNLESS_TYPE_PASS
        },
        ACTION_TYPE_STEP => {
          IF_TYPE => IF_TYPE_PASS,
          UNLESS_TYPE => UNLESS_TYPE_PASS
        },
        ACTION_TYPE_FAIL => {
          IF_TYPE => IF_TYPE_FAIL,
          UNLESS_TYPE => UNLESS_TYPE_FAIL
        },
        ACTION_TYPE_PASS => {
          IF_TYPE => IF_TYPE_PASS,
          UNLESS_TYPE => UNLESS_TYPE_PASS
        },
        SERVICE_TYPE_STEP => {
          IF_TYPE => IF_TYPE_PASS,
          UNLESS_TYPE => UNLESS_TYPE_PASS
        },
        SERVICE_TYPE_FAIL => {
          IF_TYPE => IF_TYPE_FAIL,
          UNLESS_TYPE => UNLESS_TYPE_FAIL
        },
        SERVICE_TYPE_PASS => {
          IF_TYPE => IF_TYPE_PASS,
          UNLESS_TYPE => UNLESS_TYPE_PASS
        },
        DOBY_TYPE => {
          IF_TYPE => IF_TYPE_PASS,
          UNLESS_TYPE => UNLESS_TYPE_PASS
        },
        AIDE_TYPE => {
          IF_TYPE => IF_TYPE_FAIL,
          UNLESS_TYPE => UNLESS_TYPE_FAIL
        }
      }.freeze
      STEP_TYPE_TO_RESQ_TYPE = {
        STEP_TYPE => RESQ_TYPE_STEP,
        FAIL_TYPE => RESQ_TYPE_FAIL,
        PASS_TYPE => RESQ_TYPE_PASS,
        OCTO_TYPE => RESQ_TYPE_STEP,
        WRAP_TYPE => RESQ_TYPE_STEP,
        IF_TYPE_PASS => RESQ_TYPE_STEP,
        UNLESS_TYPE_PASS => RESQ_TYPE_STEP,
        IF_TYPE_FAIL => RESQ_TYPE_FAIL,
        UNLESS_TYPE_FAIL => RESQ_TYPE_FAIL,
        DOBY_TYPE => RESQ_TYPE_STEP,
        AIDE_TYPE => RESQ_TYPE_FAIL
      }.freeze
      STEP_TYPE_TO_INNER_TYPE = {
        STEP_TYPE => ACTION_TYPE_STEP,
        FAIL_TYPE => ACTION_TYPE_FAIL,
        PASS_TYPE => ACTION_TYPE_PASS,
        RESQ_TYPE_STEP => ACTION_TYPE_STEP,
        RESQ_TYPE_FAIL => ACTION_TYPE_FAIL,
        RESQ_TYPE_PASS => ACTION_TYPE_PASS
      }.freeze
      STEP_TYPE_TO_SERVICE_TYPE = {
        STEP_TYPE => SERVICE_TYPE_STEP,
        FAIL_TYPE => SERVICE_TYPE_FAIL,
        PASS_TYPE => SERVICE_TYPE_PASS,
        RESQ_TYPE_STEP => SERVICE_TYPE_STEP,
        RESQ_TYPE_FAIL => SERVICE_TYPE_FAIL,
        RESQ_TYPE_PASS => SERVICE_TYPE_PASS
      }.freeze
      ACTION_NOT_ALLOWED_STEPS = [
        OCTO_TYPE,
        WRAP_TYPE,
        RESQ_TYPE,
        DOBY_TYPE,
        AIDE_TYPE
      ].freeze
      PASS_FLOW = [
        STEP_TYPE,
        PASS_TYPE,
        OCTO_TYPE,
        WRAP_TYPE,
        IF_TYPE_PASS,
        UNLESS_TYPE_PASS,
        ACTION_TYPE_PASS,
        ACTION_TYPE_STEP,
        SERVICE_TYPE_STEP,
        SERVICE_TYPE_PASS,
        DOBY_TYPE
      ].freeze
      FAIL_FLOW = [
        FAIL_TYPE,
        IF_TYPE_FAIL,
        UNLESS_TYPE_FAIL,
        ACTION_TYPE_FAIL,
        SERVICE_TYPE_FAIL,
        AIDE_TYPE
      ].freeze

      MAIN_FLOW_TYPES = [
        STEP_TYPE,
        FAIL_TYPE,
        PASS_TYPE,
        WRAP_TYPE,
        DOBY_TYPE,
        AIDE_TYPE
      ].freeze
      SUCCESS_TRACK_STEP_TYPES = [
        STEP_TYPE,
        PASS_TYPE,
        IF_TYPE_PASS,
        UNLESS_TYPE_PASS,
        WRAP_TYPE,
        ACTION_TYPE_STEP,
        ACTION_TYPE_PASS,
        SERVICE_TYPE_STEP,
        SERVICE_TYPE_PASS,
        RESQ_TYPE_STEP,
        RESQ_TYPE_PASS,
        OCTO_TYPE,
        DOBY_TYPE
      ].freeze
      FAILURE_TRACK_STEP_TYPES = [
        FAIL_TYPE,
        IF_TYPE_FAIL,
        UNLESS_TYPE_FAIL,
        RESQ_TYPE_FAIL,
        ACTION_TYPE_FAIL,
        SERVICE_TYPE_FAIL,
        AIDE_TYPE
      ].freeze
    end
  end
end
