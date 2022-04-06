# frozen_string_literal: true

require 'pry'

# class ErrorStore
#   attr_reader :errors

#   def initialize
#     @errors = {}
#   end

#   def add_error(key:, message:)
#     @errors.store(key, [message].flatten)
#     puts 'pidor'
#   end
# end

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

# class Comp
#   class << self
#     attr_reader :steps

#     def inherited(subclass)
#       subclass.init_steps
#     end

#     def init_steps
#       @steps = {}
#     end

#     def step(name)
#       @steps[name] = name
#     end
#   end
# end

# class One
#   class << self
#     attr_reader :lagic

#     def call
#       binding.pry
#       self
#     end

#     private

#     def logic(&block)
#       @lagic = Class.new(Comp, &block)
#       puts @logic.object_id
#     end

#     def squad(&block)
#       @squads ||= []

#       prc = Proc.new do
#         logic(&block)
#       end
#       @squads.push(
#         Class.new(One, &prc)
#       )
#     end
#   end
# end

# class Two < One
#   # logic do
#   #   step :lox
#   #   step :pidor
#   # end

#   squad do
#     step :nelox
#     step :nepidor
#   end
# end

# two = Two.call
