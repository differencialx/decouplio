module Decouplio
  class ActionStatePrinter
    def self.call(action)
      <<~INSPECT

        Result: #{result(action)}

        RailwayFlow:
          #{railway_flow(action)}

        Context:
          #{action_context(action)}

        #{meta_store(action)}

      INSPECT
    end

    private

    def self.result(action)
      action.success? ? 'success' : 'failure'
    end

    def self.railway_flow(action)
      action.railway_flow.join(' -> ')
    end

    def self.action_context(action)
      action.ctx.map { |k, v| "#{k.inspect} => #{v.inspect}" }.join("\n  ")
    end

    def self.meta_store(action)
      action.ms.to_s
    end
  end
end
