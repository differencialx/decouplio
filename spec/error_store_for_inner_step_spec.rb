# frozen_string_literal: true

class CustomErrorStore
  attr_reader :errors

  def initialize
    @errors = {}
  end

  def add_error(key:, message:, namespace: :root)
    @errors[namespace] ||= {}
    @errors[namespace].store(
      key,
      (@errors[namespace][key] || []) + [message].flatten
    )
  end

  def merge(error_store)
    @errors = deep_merge(@errors, error_store.errors)
  end

  private

  def deep_merge(this_hash, other_hash)
    this_hash.merge(other_hash) do |_key, this_val, other_val|
      if this_val.is_a?(Hash) && other_val.is_a?(Hash)
        deep_merge(this_val, other_val)
      else
        this_val + other_val
      end
    end
  end
end

RSpec.describe 'Error store for inner step' do
  context 'when error store is different for action and inner action' do
    let(:define_action_class) do
      class CustomErrorStoreWithInnerDefaultErrorHandler < Decouplio::Action
        error_store_class CustomErrorStore

        logic do
          step InnerActionWithDefaultErrorStore
          step :add_action_error
        end

        def add_action_error(**)
          add_error(
            namespace: :outer,
            key: :custom_key,
            message: 'Custom message'
          )
        end
      end
    end

    before do
      class InnerActionWithDefaultErrorStore < Decouplio::Action
        logic do
          step :add_some_error
        end

        def add_some_error(**)
          add_error(
            key: :regular_error,
            message: 'OMG this is an error!'
          )
        end
      end
    end

    it 'raises and error' do
      expect { define_action_class }.to raise_error(
        Decouplio::Errors::ErrorStoreError,
        'Error store for action and inner action should be the same.'
      )
    end
  end

  context 'when error store is the same for action and error action' do
    before do
      class InnerActionWithCustomErrorStore < Decouplio::Action
        error_store_class CustomErrorStore

        logic do
          step :add_some_error
        end

        def add_some_error(**)
          add_error(
            namespace: :inner,
            key: :regular_error,
            message: 'OMG this is an error!'
          )
        end
      end

      class CustomErrorStoreWithInnerCustomErrorHandler < Decouplio::Action
        error_store_class CustomErrorStore

        logic do
          step InnerActionWithCustomErrorStore
          step :add_action_error
        end

        def add_action_error(**)
          add_error(
            namespace: :outer,
            key: :custom_key,
            message: 'Custom message'
          )
        end
      end
    end

    it 'success' do
      action = CustomErrorStoreWithInnerCustomErrorHandler.call
      expect(action).to be_success
      expect(action.errors).to eq(
        {
          inner: {
            regular_error: ['OMG this is an error!']
          },
          outer: {
            custom_key: ['Custom message']
          }
        }
      )
    end
  end
end
