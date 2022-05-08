# frozen_string_literal: true

require_relative 'const/types'
require_relative 'const/results'
require_relative 'steps/step'
require_relative 'steps/fail'
require_relative 'steps/pass'
require_relative 'steps/wrap'
require_relative 'steps/octo'
require_relative 'steps/resq_pass'
require_relative 'steps/resq_fail'
require_relative 'steps/if_condition_pass'
require_relative 'steps/if_condition_fail'
require_relative 'steps/unless_condition_pass'
require_relative 'steps/unless_condition_fail'
require_relative 'steps/inner_action_step'
require_relative 'steps/inner_action_fail'
require_relative 'steps/inner_action_pass'
require_relative 'options_validator'

module Decouplio
  class Composer
    class << self
      def compose(logic_container_raw_data:, palp_prefix: :root, parent_flow: {}, next_steps: nil)
        flow = logic_container_raw_data.steps
        palps = logic_container_raw_data.palps

        steps_pool = {}
        steps_flow = {}

        flow = prepare_raw_data(flow, palp_prefix)
        validate_flow(flow, palps, next_steps)
        flow = compose_flow(flow, palps, next_steps, parent_flow)

        flow.each do |step_id, stp|
          steps_flow[step_id] = stp[:flow]
          steps_flow.merge!(extract_palp_flow(stp))
          steps_pool[step_id] = create_step_instance(stp, flow)
          steps_pool.merge!(extract_palp_pool(stp))
        end

        {
          first_step: steps_pool.keys.first,
          steps_pool: steps_pool.freeze,
          steps_flow: steps_flow.freeze
        }
      end

      private

      def prepare_raw_data(flow, palp_prefix)
        flow = flow.map do |stp|
          stp[:step_id] = random_id(name: stp[:name], palp_prefix: palp_prefix, flow: flow)
          stp[:flow] = {}
          stp = compose_resq(stp, palp_prefix, flow)
          stp = compose_action(stp)
          condition = compose_condition(stp, palp_prefix, flow)

          [condition, stp].compact
        end.flatten

        flow.to_h do |stp|
          [stp[:step_id], stp]
        end
      end

      def validate_flow(flow, palps, next_steps)
        OptionsValidator.new(flow: flow, palps: palps, next_steps: next_steps).call
      end

      def extract_palp_flow(stp)
        return {} unless stp[:type] == Decouplio::Const::Types::OCTO_TYPE

        stp[:hash_case].values.map { |composer_output| composer_output[:steps_flow] }.reduce({}, :merge)
      end

      def extract_palp_pool(stp)
        return {} unless stp[:type] == Decouplio::Const::Types::OCTO_TYPE

        stp[:hash_case].values.map { |composer_output| composer_output[:steps_pool] }.reduce({}, :merge)
      end

      def create_step_instance(stp, flow)
        case stp[:type]
        when Decouplio::Const::Types::STEP_TYPE
          create_step(stp, flow)
        when Decouplio::Const::Types::FAIL_TYPE
          create_fail(stp, flow)
        when Decouplio::Const::Types::PASS_TYPE
          create_pass(stp, flow)
        when Decouplio::Const::Types::IF_TYPE_PASS
          create_if_condition_pass(stp)
        when Decouplio::Const::Types::IF_TYPE_FAIL
          create_if_condition_fail(stp)
        when Decouplio::Const::Types::UNLESS_TYPE_PASS
          create_unless_condition_pass(stp)
        when Decouplio::Const::Types::UNLESS_TYPE_FAIL
          create_unless_condition_fail(stp)
        when Decouplio::Const::Types::OCTO_TYPE
          create_octo(stp)
        when Decouplio::Const::Types::WRAP_TYPE
          create_wrap(flow, stp)
        when Decouplio::Const::Types::RESQ_TYPE_STEP, Decouplio::Const::Types::RESQ_TYPE_PASS
          create_resq_pass(stp, flow)
        when Decouplio::Const::Types::RESQ_TYPE_FAIL
          create_resq_fail(stp, flow)
        when Decouplio::Const::Types::ACTION_TYPE_STEP
          create_inner_action_step(stp, flow)
        when Decouplio::Const::Types::ACTION_TYPE_FAIL
          create_inner_action_fail(stp, flow)
        when Decouplio::Const::Types::ACTION_TYPE_PASS
          create_inner_action_pass(stp, flow)
        end
      end

      def create_step(stp, flow)
        Decouplio::Steps::Step.new(
          name: stp[:name],
          on_success_type: success_type(flow, stp),
          on_failure_type: failure_type(flow, stp)
        )
      end

      def create_fail(stp, flow)
        Decouplio::Steps::Fail.new(
          name: stp[:name],
          on_success_type: success_type(flow, stp),
          on_failure_type: failure_type(flow, stp)
        )
      end

      def create_pass(stp, flow)
        Decouplio::Steps::Pass.new(
          name: stp[:name],
          on_success_type: success_type(flow, stp)
        )
      end

      def create_if_condition_pass(stp)
        Decouplio::Steps::IfConditionPass.new(
          name: stp[:name]
        )
      end

      def create_if_condition_fail(stp)
        Decouplio::Steps::IfConditionFail.new(
          name: stp[:name]
        )
      end

      def create_unless_condition_pass(stp)
        Decouplio::Steps::UnlessConditionPass.new(
          name: stp[:name]
        )
      end

      def create_unless_condition_fail(stp)
        Decouplio::Steps::UnlessConditionFail.new(
          name: stp[:name]
        )
      end

      def create_octo(stp)
        Decouplio::Steps::Octo.new(
          name: stp[:name],
          ctx_key: stp[:ctx_key]
        )
      end

      def create_wrap(flow, stp)
        Decouplio::Steps::Wrap.new(
          name: stp[:name],
          klass: stp[:klass],
          method: stp[:method],
          wrap_flow: stp[:wrap_flow],
          on_success_type: success_type(flow, stp),
          on_failure_type: failure_type(flow, stp)
        )
      end

      def create_resq_pass(stp, flow)
        Decouplio::Steps::ResqPass.new(
          handler_hash: stp[:handler_hash],
          step_to_resq: create_step_instance(stp[:step_to_resq], flow)
        )
      end

      def create_resq_fail(stp, flow)
        Decouplio::Steps::ResqFail.new(
          handler_hash: stp[:handler_hash],
          step_to_resq: create_step_instance(stp[:step_to_resq], flow)
        )
      end

      def create_inner_action_step(stp, flow)
        Decouplio::Steps::InnerActionStep.new(
          name: stp[:name],
          action: stp[:action],
          on_success_type: success_type(flow, stp),
          on_failure_type: failure_type(flow, stp)
        )
      end

      def create_inner_action_fail(stp, flow)
        Decouplio::Steps::InnerActionFail.new(
          name: stp[:name],
          action: stp[:action],
          on_success_type: success_type(flow, stp),
          on_failure_type: failure_type(flow, stp)
        )
      end

      def create_inner_action_pass(stp, flow)
        Decouplio::Steps::InnerActionPass.new(
          name: stp[:name],
          action: stp[:action],
          on_success_type: success_type(flow, stp),
          on_failure_type: failure_type(flow, stp)
        )
      end

      def compose_flow(flow, palps, next_steps, flow_hash = {})
        flow.each_with_index do |(step_id, stp), idx|
          case stp[:type]
          when Decouplio::Const::Types::STEP_TYPE,
               Decouplio::Const::Types::PASS_TYPE,
               Decouplio::Const::Types::WRAP_TYPE,
               Decouplio::Const::Types::ACTION_TYPE_STEP,
               Decouplio::Const::Types::ACTION_TYPE_PASS,
               Decouplio::Const::Types::RESQ_TYPE_STEP,
               Decouplio::Const::Types::RESQ_TYPE_PASS
            compose_step_flow(stp, step_id, flow, idx, flow_hash, next_steps)
          when Decouplio::Const::Types::FAIL_TYPE,
               Decouplio::Const::Types::RESQ_TYPE_FAIL,
               Decouplio::Const::Types::ACTION_TYPE_FAIL
            compose_fail_flow(stp, step_id, flow, idx, flow_hash, next_steps)
          when Decouplio::Const::Types::IF_TYPE_PASS, Decouplio::Const::Types::UNLESS_TYPE_PASS
            compose_pass_condition_flow(stp, flow, idx, flow_hash)
          when Decouplio::Const::Types::IF_TYPE_FAIL, Decouplio::Const::Types::UNLESS_TYPE_FAIL
            compose_fail_condition_flow(stp, flow, idx, flow_hash)
          when Decouplio::Const::Types::OCTO_TYPE
            compose_octo_flow(stp, step_id, idx, flow, palps, flow_hash)
          end
        end
      end

      def compose_step_flow(stp, step_id, flow, idx, flow_hash, next_steps)
        flow_values = flow.values + (next_steps&.values || [])
        stp[:flow][Decouplio::Const::Results::PASS] = next_success_step(
          flow_values,
          idx,
          flow[step_id][:on_success]
        )
        stp[:flow][Decouplio::Const::Results::FAIL] = next_failure_step(
          flow_values,
          idx,
          flow[step_id][:on_failure]
        )
        stp[:flow][Decouplio::Const::Results::ERROR] = next_failure_step(
          flow_values,
          idx,
          flow[step_id][:on_error]
        )
        stp[:flow][Decouplio::Const::Results::PASS] ||= flow_hash[Decouplio::Const::Results::PASS]
        stp[:flow][Decouplio::Const::Results::FAIL] ||= flow_hash[Decouplio::Const::Results::FAIL]
        stp[:flow][Decouplio::Const::Results::ERROR] ||= flow_hash[Decouplio::Const::Results::ERROR]
        stp[:flow][Decouplio::Const::Results::FINISH_HIM] = Decouplio::Const::Results::NO_STEP
      end

      def compose_fail_flow(stp, step_id, flow, idx, flow_hash, next_steps)
        flow_values = flow.values + (next_steps&.values || [])
        stp[:flow][Decouplio::Const::Results::PASS] = next_failure_step(
          flow_values,
          idx,
          flow[step_id][:on_success]
        )
        stp[:flow][Decouplio::Const::Results::FAIL] = next_failure_step(
          flow_values,
          idx,
          flow[step_id][:on_failure]
        )
        stp[:flow][Decouplio::Const::Results::ERROR] = next_failure_step(
          flow_values,
          idx,
          flow[step_id][:on_error]
        )
        stp[:flow][Decouplio::Const::Results::PASS] ||= flow_hash[Decouplio::Const::Results::FAIL]
        stp[:flow][Decouplio::Const::Results::FAIL] ||= flow_hash[Decouplio::Const::Results::FAIL]
        stp[:flow][Decouplio::Const::Results::ERROR] ||= flow_hash[Decouplio::Const::Results::ERROR]
        stp[:flow][Decouplio::Const::Results::FINISH_HIM] = Decouplio::Const::Results::NO_STEP
      end

      def compose_pass_condition_flow(stp, flow, idx, flow_hash)
        stp[:flow][Decouplio::Const::Results::PASS] = next_success_step(flow.values, idx, nil)
        stp[:flow][Decouplio::Const::Results::FAIL] = next_success_step(flow.values, idx + 1, nil)
        stp[:flow][Decouplio::Const::Results::FAIL] ||= flow_hash[Decouplio::Const::Results::PASS]
      end

      def compose_fail_condition_flow(stp, flow, idx, flow_hash)
        stp[:flow][Decouplio::Const::Results::PASS] = next_failure_step(flow.values, idx, nil)
        stp[:flow][Decouplio::Const::Results::FAIL] = next_failure_step(flow.values, idx + 1, nil)
        stp[:flow][Decouplio::Const::Results::FAIL] ||= flow_hash[Decouplio::Const::Results::FAIL]
      end

      def compose_octo_flow(stp, step_id, idx, flow, palps, flow_hash)
        stp[:flow][Decouplio::Const::Results::PASS] = next_success_step(
          flow.values,
          idx,
          flow[step_id][:on_success]
        )
        stp[:flow][Decouplio::Const::Results::FAIL] = next_failure_step(
          flow.values,
          idx,
          flow[step_id][:on_failure]
        )
        stp[:flow][Decouplio::Const::Results::PASS] ||= flow_hash[Decouplio::Const::Results::PASS]
        stp[:flow][Decouplio::Const::Results::FAIL] ||= flow_hash[Decouplio::Const::Results::FAIL]
        stp[:flow][Decouplio::Const::Results::FINISH_HIM] = Decouplio::Const::Results::NO_STEP
        stp = compose_strategy(stp, palps, flow.to_a[(idx + 1)..].to_h)
        stp[:hash_case].each do |strategy_key, strategy_raw_data|
          stp[:flow][strategy_key] = strategy_raw_data[:first_step]
        end
      end

      def success_type(flow, stp)
        return :finish_him if [:on_success, true].include?(finish_him(stp))

        step_id = stp.dig(:flow, Decouplio::Const::Results::PASS)
        Decouplio::Const::Types::PASS_FLOW.include?(
          flow[step_id]&.[](:type)
        )
      end

      def failure_type(flow, stp)
        return :finish_him if [:on_failure, true].include?(finish_him(stp))

        step_id = stp.dig(:flow, Decouplio::Const::Results::FAIL)
        Decouplio::Const::Types::FAIL_FLOW.include?(
          flow[step_id]&.[](:type)
        )
      end

      def finish_him(stp)
        if stp[:on_success] == :finish_him
          :on_success
        elsif stp[:on_failure] == :finish_him
          :on_failure
        elsif stp.key?(:finish_him)
          stp[:finish_him]
        end
      end

      def compose_condition(stp, palp_prefix, flow)
        condition_options = stp.slice(:if, :unless)

        return if condition_options.empty?

        condition = ([%i[name type]] + condition_options.invert.to_a).transpose.to_h
        condition[:step_id] = random_id(name: condition[:name], palp_prefix: palp_prefix, flow: flow)
        condition[:type] = Decouplio::Const::Types::STEP_TYPE_TO_CONDITION_TYPE.dig(stp[:type], condition[:type])
        condition[:flow] = {}
        condition
      end

      def compose_action(stp)
        return stp if Decouplio::Const::Types::ACTION_NOT_ALLOWED_STEPS.include?(stp[:type])

        if stp.key?(:action)
          stp[:type] = Decouplio::Const::Types::STEP_TYPE_TO_INNER_TYPE[stp[:type]]
        elsif stp.dig(:step_to_resq, :action)
          stp[:step_to_resq][:type] = Decouplio::Const::Types::STEP_TYPE_TO_INNER_TYPE[stp[:type]]
        end

        stp
      end

      def compose_strategy(stp, palps, next_steps)
        return stp unless stp[:type] == Decouplio::Const::Types::OCTO_TYPE

        stp[:hash_case] = stp[:hash_case].to_h do |strategy_key, options|
          strategy_flow = compose(
            logic_container_raw_data: palps[options[:palp]],
            palp_prefix: options[:palp],
            parent_flow: stp[:flow],
            next_steps: next_steps
          )
          [
            strategy_key,
            strategy_flow
          ]
        end
        stp
      end

      def compose_resq(stp, palp_prefix, flow)
        return stp unless stp[:type] == Decouplio::Const::Types::RESQ_TYPE

        options_for_resq = stp[:step_to_resq].slice(
          :on_success,
          :on_failure,
          :finish_him,
          :if,
          :unless
        )
        stp[:step_id] = random_id(name: stp[:name], palp_prefix: palp_prefix, flow: flow)
        stp[:flow] = {}
        handler_hash = {}
        stp[:handler_hash].each do |handler_method, error_classes|
          [error_classes].flatten.each do |error_class|
            handler_hash[error_class] = handler_method
          end
        end
        stp[:handler_hash] = handler_hash
        stp[:type] = Decouplio::Const::Types::STEP_TYPE_TO_RESQ_TYPE[stp[:step_to_resq][:type]]
        stp.merge(options_for_resq)
      end

      def next_success_step(steps, idx, value)
        steps_slice = steps[(idx + 1)..]
        steps_slice.each_with_index do |stp, index|
          if value == stp[:name]
            prev_step = steps_slice[index - 1]
            if [
              Decouplio::Const::Types::IF_TYPE_PASS,
              Decouplio::Const::Types::UNLESS_TYPE_PASS
            ].include?(prev_step[:type])
              return prev_step[:step_id]
            else
              return stp[:step_id]
            end
          elsif !value && [
            Decouplio::Const::Types::STEP_TYPE,
            Decouplio::Const::Types::PASS_TYPE,
            Decouplio::Const::Types::IF_TYPE_PASS,
            Decouplio::Const::Types::UNLESS_TYPE_PASS,
            Decouplio::Const::Types::WRAP_TYPE,
            Decouplio::Const::Types::ACTION_TYPE_STEP,
            Decouplio::Const::Types::ACTION_TYPE_PASS,
            Decouplio::Const::Types::RESQ_TYPE_STEP,
            Decouplio::Const::Types::RESQ_TYPE_PASS,
            Decouplio::Const::Types::OCTO_TYPE
          ].include?(stp[:type])
            return stp[:step_id]
          end
        end

        Decouplio::Const::Results::NO_STEP
      end

      def next_failure_step(steps, idx, value)
        steps_slice = steps[(idx + 1)..]
        steps_slice.each_with_index do |stp, index|
          if value == stp[:name]
            prev_step = steps_slice[index - 1]
            if [
              Decouplio::Const::Types::IF_TYPE_FAIL,
              Decouplio::Const::Types::UNLESS_TYPE_FAIL
            ].include?(prev_step[:type])
              # return step_id
              return prev_step[:step_id]
            else
              return stp[:step_id]
            end
          elsif !value && [
            Decouplio::Const::Types::FAIL_TYPE,
            Decouplio::Const::Types::IF_TYPE_FAIL,
            Decouplio::Const::Types::UNLESS_TYPE_FAIL,
            Decouplio::Const::Types::RESQ_TYPE_FAIL,
            Decouplio::Const::Types::ACTION_TYPE_FAIL
          ].include?(stp[:type])
            return stp[:step_id]
          end
        end

        Decouplio::Const::Results::NO_STEP
      end

      def random_id(name:, palp_prefix:, flow:)
        loop do
          random_step_id =
            "#{palp_prefix}_#{name}_#{random_value}#{random_value}#{random_value}#{random_value}#{random_value}".to_sym

          break random_step_id if flow.select { |stp| stp[:step_id] == random_step_id }.empty?
        end
      end

      def random_value
        (10..99).to_a.sample
      end
    end
  end
end
