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
require_relative 'steps/inner_action'

module Decouplio
  class Composer
    def self.compose(logic_container_raw_data:, squad_prefix: :root, parent_flow: {})
      flow = logic_container_raw_data.steps
      squads = logic_container_raw_data.squads

      steps_pool = {}
      steps_flow = {}


      flow = prepare_raw_data(flow, squad_prefix)

      flow = compose_flow(flow, squads, parent_flow)

      flow.each do |step_id, stp|
        steps_flow[step_id] = stp[:flow]
        steps_flow.merge!(extract_squad_flow(stp))
        steps_pool[step_id] = create_step_instance(stp, flow)
        steps_pool.merge!(extract_squad_pool(stp))
      end

      {
        first_step: steps_pool.keys.first,
        steps_pool: steps_pool,
        steps_flow: steps_flow
      }
    end

    private

    def self.prepare_raw_data(flow, squad_prefix)
      flow = flow.map do |stp|
        stp[:step_id] = random_id(name: stp[:name], squad_prefix: squad_prefix)
        stp[:flow] = {}
        stp = compose_resq(stp, squad_prefix)
        stp = compose_action(stp)
        condition = compose_condition(stp, squad_prefix)
        [condition, stp].compact
      end.flatten

      flow.map do |stp|
        [stp[:step_id], stp]
      end.to_h
    end

    def self.extract_squad_flow(stp)
      return {} unless stp[:type] == Decouplio::Const::OCTO_TYPE

      stp[:hash_case].values.map { |composer_output| composer_output[:steps_flow] }.reduce({}, :merge)
    end

    def self.extract_squad_pool(stp)
      return {} unless stp[:type] == Decouplio::Const::OCTO_TYPE

      stp[:hash_case].values.map { |composer_output| composer_output[:steps_pool] }.reduce({}, :merge)
    end

    def self.create_step_instance(stp, flow)
      case stp[:type]
      when Decouplio::Const::STEP_TYPE
        Decouplio::Steps::Step.new(
          name: stp[:name],
          finish_him: finish_him(stp),
          on_success_type: Decouplio::Const::PASS_FLOW.include?(flow[stp.dig(:flow, Decouplio::Const::PASS)]&.[](:type)),
          on_failure_type: Decouplio::Const::FAIL_FLOW.include?(flow[stp.dig(:flow, Decouplio::Const::FAIL)]&.[](:type))
        )
      when Decouplio::Const::FAIL_TYPE
        Decouplio::Steps::Fail.new(
          name: stp[:name],
          finish_him: finish_him(stp)
        )
      when Decouplio::Const::PASS_TYPE
        Decouplio::Steps::Pass.new(
          name: stp[:name],
          finish_him: finish_him(stp)
        )
      when Decouplio::Const::IF_TYPE_PASS
        Decouplio::Steps::IfConditionPass.new(
          name: stp[:name]
        )
      when Decouplio::Const::IF_TYPE_FAIL
        Decouplio::Steps::IfConditionFail.new(
          name: stp[:name]
        )
      when Decouplio::Const::UNLESS_TYPE_PASS
        Decouplio::Steps::UnlessConditionPass.new(
          name: stp[:name]
        )
      when Decouplio::Const::UNLESS_TYPE_FAIL
        Decouplio::Steps::UnlessConditionFail.new(
          name: stp[:name]
        )
      when Decouplio::Const::OCTO_TYPE
        Decouplio::Steps::Octo.new(
          name: stp[:name],
          ctx_key: stp[:ctx_key]
        )
      when Decouplio::Const::WRAP_TYPE
        Decouplio::Steps::Wrap.new(
          name: stp[:name],
          klass: stp[:klass],
          method: stp[:method],
          wrap_flow: stp[:wrap_flow],
          finish_him: finish_him(stp)
        )
      when Decouplio::Const::RESQ_TYPE_PASS
        Decouplio::Steps::ResqPass.new(
          handler_hash: stp[:handler_hash],
          step_to_resq: create_step_instance(stp[:step_to_resq], flow)
        )
      when Decouplio::Const::RESQ_TYPE_FAIL
        Decouplio::Steps::ResqFail.new(
          handler_hash: stp[:handler_hash],
          step_to_resq: create_step_instance(stp[:step_to_resq], flow)
        )
      when Decouplio::Const::ACTION_TYPE
        Decouplio::Steps::InnerAction.new(
          name: stp[:name],
          action: stp[:action],
          finish_him: finish_him(stp),
          on_success_type: Decouplio::Const::PASS_FLOW.include?(flow[stp.dig(:flow, Decouplio::Const::PASS)]&.[](:type)),
          on_failure_type: Decouplio::Const::FAIL_FLOW.include?(flow[stp.dig(:flow, Decouplio::Const::FAIL)]&.[](:type))
        )
      end
    end

    def self.compose_flow(flow, squads, flow_hash = {})
      flow.each_with_index do |(step_id, stp), idx|
        case stp[:type]
        when Decouplio::Const::STEP_TYPE,
             Decouplio::Const::PASS_TYPE,
             Decouplio::Const::WRAP_TYPE,
             Decouplio::Const::ACTION_TYPE,
             Decouplio::Const::RESQ_TYPE_PASS
          stp[:flow][Decouplio::Const::PASS] = next_success_step(flow.values, idx, flow[step_id][:on_success])
          stp[:flow][Decouplio::Const::FAIL] = next_failure_step(flow.values, idx, flow[step_id][:on_failure])
          stp[:flow][Decouplio::Const::PASS] ||= flow_hash[Decouplio::Const::PASS]
          stp[:flow][Decouplio::Const::FAIL] ||= flow_hash[Decouplio::Const::FAIL]
          stp[:flow][Decouplio::Const::FINISH_HIM] = Decouplio::Const::NO_STEP
        when Decouplio::Const::FAIL_TYPE, Decouplio::Const::RESQ_TYPE_FAIL
          stp[:flow][Decouplio::Const::FAIL] = next_failure_step(flow.values, idx, flow[step_id][:on_failure])
          stp[:flow][Decouplio::Const::FAIL] ||= flow_hash[Decouplio::Const::FAIL]
          stp[:flow][Decouplio::Const::FINISH_HIM] = Decouplio::Const::NO_STEP
        when Decouplio::Const::IF_TYPE_PASS
          stp[:flow][Decouplio::Const::PASS] = next_success_step(flow.values, idx, nil)
          stp[:flow][Decouplio::Const::FAIL] = next_success_step(flow.values, idx + 1, nil)
          stp[:flow][Decouplio::Const::FAIL] ||= flow_hash[Decouplio::Const::PASS]
        when Decouplio::Const::IF_TYPE_FAIL
          stp[:flow][Decouplio::Const::PASS] = next_failure_step(flow.values, idx, nil)
          stp[:flow][Decouplio::Const::FAIL] = next_failure_step(flow.values, idx + 1, nil)
          stp[:flow][Decouplio::Const::FAIL] ||= flow_hash[Decouplio::Const::FAIL]
        when Decouplio::Const::UNLESS_TYPE_PASS
          stp[:flow][Decouplio::Const::PASS] = next_success_step(flow.values, idx, nil)
          stp[:flow][Decouplio::Const::FAIL] = next_success_step(flow.values, idx + 1, nil)
          stp[:flow][Decouplio::Const::FAIL] ||= flow_hash[Decouplio::Const::PASS]
        when Decouplio::Const::UNLESS_TYPE_FAIL
          stp[:flow][Decouplio::Const::PASS] = next_failure_step(flow.values, idx, nil)
          stp[:flow][Decouplio::Const::FAIL] = next_failure_step(flow.values, idx + 1, nil)
          stp[:flow][Decouplio::Const::FAIL] ||= flow_hash[Decouplio::Const::FAIL]
        when Decouplio::Const::OCTO_TYPE
          stp[:flow][Decouplio::Const::PASS] = next_success_step(flow.values, idx, flow[step_id][:on_success])
          stp[:flow][Decouplio::Const::FAIL] = next_failure_step(flow.values, idx, flow[step_id][:on_failure])
          stp[:flow][Decouplio::Const::PASS] ||= flow_hash[Decouplio::Const::PASS]
          stp[:flow][Decouplio::Const::FAIL] ||= flow_hash[Decouplio::Const::FAIL]
          stp[:flow][Decouplio::Const::FINISH_HIM] = Decouplio::Const::NO_STEP
          stp = compose_strategy(stp, squads)
          stp[:hash_case].each do |strategy_key, strategy_raw_data|
            stp[:flow][strategy_key] = strategy_raw_data[:first_step]
          end
        end
      end
    end

    def self.compose_condition(stp, squad_prefix)
      condition_options = stp.slice(:if, :unless)

      return if condition_options.empty?

      condition = ([%i[name type]] + condition_options.invert.to_a).transpose.to_h
      condition[:step_id] = random_id(name: condition[:name], squad_prefix: squad_prefix)
      condition[:type] = Decouplio::Const::STEP_TYPE_TO_CONDITION_TYPE.dig(stp[:type], condition[:type])
      condition[:flow] = {}
      condition
    end

    def self.compose_action(stp)
      # TODO: && stp is_a_step_type, means that wrap, strategy, squad, resq does not accept action: key, add validations and tests

      return stp unless stp.key?(:action) || stp.dig(:step_to_resq, :action)

      if stp[:type] == Decouplio::Const::RESQ_TYPE
        stp[:step_to_resq][:type] = Decouplio::Const::ACTION_TYPE
      else
        stp[:type] = Decouplio::Const::ACTION_TYPE
      end

      stp
    end

    def self.compose_strategy(stp, squads)
      return stp unless stp[:type] == Decouplio::Const::OCTO_TYPE

      stp[:hash_case] = stp[:hash_case].map do |strategy_key, options|
        strategy_flow = compose(logic_container_raw_data: squads[options[:squad]], squad_prefix: options[:squad], parent_flow: stp[:flow])
        [
          strategy_key,
          strategy_flow
        ]
      end.to_h
      stp
    end

    def self.compose_resq(stp, squad_prefix)
      return stp unless stp[:type] == Decouplio::Const::RESQ_TYPE

      options_for_resq = stp[:step_to_resq].slice(
        :on_success,
        :on_failure,
        :finish_him,
        :if,
        :unless
      )
      stp[:step_id] = random_id(name: stp[:name], squad_prefix: squad_prefix)
      stp[:flow] = {}
      handler_hash = {}
      stp[:handler_hash].each do |handler_method, error_classes|
        [error_classes].flatten.each do |error_class|
          handler_hash[error_class] = handler_method
        end
      end
      stp[:handler_hash] = handler_hash
      stp[:type] = Decouplio::Const::STEP_TYPE_TO_RESQ_TYPE.dig(stp[:step_to_resq][:type])
      stp.merge(options_for_resq)
    end

    def self.finish_him(stp)
      if stp[:on_success] == :finish_him
        :on_success
      elsif stp[:on_failure] == :finish_him
        :on_failure
      elsif stp.key?(:finish_him)
        stp[:finish_him]
      end
    end

    def self.next_success_step(steps, idx, value)
      steps_slice = steps[(idx + 1)..-1]
      steps_slice.each_with_index do |stp, index|
        if value == stp[:name]
          prev_step = steps_slice[index - 1]
          if [
            Decouplio::Const::IF_TYPE_PASS,
            Decouplio::Const::UNLESS_TYPE_PASS
          ].include?(prev_step[:type])
            return prev_step[:step_id]
          else
            return stp[:step_id]
          end
        elsif !value && [
          Decouplio::Const::STEP_TYPE,
          Decouplio::Const::PASS_TYPE,
          Decouplio::Const::IF_TYPE_PASS,
          Decouplio::Const::UNLESS_TYPE_PASS,
          Decouplio::Const::WRAP_TYPE,
          Decouplio::Const::ACTION_TYPE,
          Decouplio::Const::RESQ_TYPE_PASS,
          Decouplio::Const::OCTO_TYPE
        ].include?(stp[:type])
          return stp[:step_id]
        end
      end

      Decouplio::Const::NO_STEP
    end

    def self.next_failure_step(steps, idx, value)
      steps_slice = steps[(idx + 1)..-1]
      steps_slice.each_with_index do |stp, index|
        if value == stp[:name]
          prev_step = steps_slice[index - 1]
          if [
            Decouplio::Const::IF_TYPE_FAIL,
            Decouplio::Const::UNLESS_TYPE_FAIL
          ].include?(prev_step[:type])
            # return step_id
            return prev_step[:step_id]
          else
            return stp[:step_id]
          end
        elsif !value && [
          Decouplio::Const::FAIL_TYPE,
          Decouplio::Const::IF_TYPE_FAIL,
          Decouplio::Const::UNLESS_TYPE_FAIL,
          Decouplio::Const::RESQ_TYPE_FAIL
        ].include?(stp[:type])
          return stp[:step_id]
        end
      end

      Decouplio::Const::NO_STEP
    end

    def self.random_id(name:, squad_prefix:)
      # TODO: invent new approach for random step id generation
      # because there may be issues with stub rand method in specs
      # and also still there may be a case with id colission
      "#{squad_prefix}_#{name}_#{random_value}#{random_value}#{random_value}#{random_value}#{random_value}".to_sym
    end

    def self.random_value
      rand(10..99)
    end
  end
end
