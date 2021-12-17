{
  step_one: { suc: :strg_one }
  strg_one: { suc: :step_two }
  step_two: { suc: :lox }
}

{
  main_stack: {
    step1: { suc: %i[main_stack strg1] }
    strg1: { suc: %i[main_stack step2], ctx_key: :strg, hash_case: { strg_1: { type: :squad, name: :squad_one } } }
    step2: { suc: nil }
  }
  strg1: {
    squad_one: {
      step3: { suc: %i[squad_one step4] }
      some_generated_val: { type: :condition, method: :method }
      step4: { suc: %i[squad_one step5] }
      step5: { suc: nil }
    }
  }
  squad_one: {
    step3: { suc: %i[squad_one step4] }
    some_generated_val: { type: :condition, method: :method }
    step4: { suc: %i[squad_one step5] }
    step5: { suc: nil }
  }
}

def process_step(stack: :main_stack, stp:)
  # stp here is %i[main_stack <some step>]
  case @steps[stack][stp][:type]
  when :strg
    strg_keys = @steps[stp][:hash_case][instance.ctx[@steps[stp][:ctx_key]]]
    if @steps[strg_keys[:type]] == :squad
      first_step = @steps[strg_keys[:name]].keys.first
    end
  end
  process_step(stack: strg_keys[:name], stp: first_step)

  if stack != :main_stack

  end
end