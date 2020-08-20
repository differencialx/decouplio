# frozen_string_literal: true

# rubocop:disable Lint/NestedMethodDefinition
module PrepareParamsCases
  # def prepare_params_block
  #   lambda do |_klass|
  #     prepare_params do |params|
  #       {
  #         id: params[:args].delete(:id),
  #         args: params[:args],
  #         user: params[:current_user]
  #       }
  #     end

  #     step :params_to_ctx

  #     def params_to_ctx(**params)
  #       ctx[:params] = params
  #     end
  #   end
  # end

  # def prepare_params_returns_nil
  #   lambda do |_klass|
  #     prepare_params do |params|
  #     end

  #     step :params_to_ctx

  #     def params_to_ctx(**params)
  #       ctx[:params] = params
  #     end
  #   end
  # end

  # def prepare_params_returns_array
  #   lambda do |_klass|
  #     prepare_params do |params|
  #       []
  #     end

  #     step :params_to_ctx

  #     def params_to_ctx(**params)
  #       ctx[:params] = params
  #     end
  #   end
  # end

  # def prepare_params_step_and_class_is_given
  #   lambda do |_klass|
  #     prepare_params :prepare_params do |params|
  #       {
  #         id: params[:args].delete(:id),
  #         args: params[:args],
  #         user: params[:current_user]
  #       }
  #     end

  #     step :params_to_ctx

  #     def params_to_ctx(**params)
  #       ctx[:params] = params
  #     end

  #     def prepare_params(**args)
  #       {
  #         id: params[:args].delete(:id),
  #         args: params[:args],
  #         user: params[:current_user]
  #       }
  #     end
  #   end
  # end

  # def prepare_params_method
  #   lambda do |_klass|
  #     prepare_params :prepare_params
  #     step :params_to_ctx

  #     def prepare_params(**args)
  #       {
  #         id: params[:args].delete(:id),
  #         args: params[:args],
  #         user: params[:current_user]
  #       }
  #     end

  #     def params_to_ctx(**params)
  #       ctx[:params] = params
  #     end
  #   end
  # end

  # PrepareParamsAction = Class.new(Decouplio::Action) do
  #   prepare_params do |params|
  #     {
  #       id: params[:args].delete(:id),
  #       args: params[:args],
  #       user: params[:current_user]
  #     }
  #   end
  # end

  # def prepare_params_with_action
  #   lambda do |_klass|
  #     prepare_params PrepareParamsAction
  #     step :params_to_ctx

  #     def params_to_ctx(**params)
  #       ctx[:params] = params
  #     end
  #   end
  # end
end
# rubocop:enable Lint/NestedMethodDefinition
