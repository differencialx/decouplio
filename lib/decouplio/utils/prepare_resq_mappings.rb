# frozen_string_literal: true

module Decouplio
  module Utils
    class PrepareResqMappings
      def self.call(mappings)
        prepared_mappings = {}
        mappings.each do |handler_method, error_classes|
          [error_classes].flatten.each do |error_class|
            prepared_mappings[error_class] = handler_method
          end
        end
        prepared_mappings
      end
    end
  end
end
