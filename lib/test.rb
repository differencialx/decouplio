class ErrorStore
  attr_reader :errors

  def initialize
    @errors = {}
  end

  def add_error(key:, message:)
    @errors.store(key, [message].flatten)
    puts 'pidor'
  end
end

# class Default < Decouplio::Action
#   step :one

#   def one(**)
#     add_error('pidor', 'lox')
#   end
# end


# class One < Decouplio::Action
#   error_store_instance ErrorStore.new
#   step :one

#   def one(**)
#     add_error(key: :pidor, message: 'lox')
#   end
# end


# class Two < One
#   step :two

#   def two(**)
#     add_error(key: :pidor, message: 'pidor')
#   end
# end
 
class DecouplioStack < Hash
  def initialize(squads:, ctx:)
    @ctx = ctx
    @squads = squads
    super
  end

  def pop
    element_key = self.first.first
    case self[element_key][:type]
    when :step
      self.delete(element_key)
    when :strategy
      strg_config = self.delete(element_key)
      
      binding.pry
    end
    
  end
end

def init
  @ctx = { strg_key: :sqd1 }
  @squads = {sqd1: {stp1: {type: :step}, stp2: {type: :step}}, sqd2: { stp3: {type: :step}, stp4: {type: :step} }}
  @stakk =  DecouplioStack.new(squads: @squads, ctx: @ctx)
  @stakk[:stp0] = { type: :step }
  @stakk[:strg] = { type: :strategy, ctx_key: :strg_key }
end
