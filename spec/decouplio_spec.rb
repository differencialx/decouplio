# frozen_string_literal: true

RSpec.describe Decouplio do
  context 'steps' do
    class ClassWithWrapperMethodError < StandardError; end
    class ClassWithWrapperMethod
      def self.transaction(&block)
        raise ClassWithWrapperMethodError
        block.call
      end
    end
    let(:dummy_class) do
      Class.new(Decouplio::Action) do
        validate_inputs do
          required(:string_param).filled(:str?)
          required(:integer_param).filled(:int?)
          required(:array_param).filled(:array?)
        end

        validate :first_validation

        step :step_one

        # wrap klass: ClassWithWrapperMethod, method: :transaction do

        # end

        # iteration class: ProcessIterator

        def step_one(string_param:, **)
          string_param
        end

        def first_validation(string_param:, integer_param:, **)
          return if string_param.to_i == integer_param

          add_error(:invalid_string_param, 'Invalid string param')
        end
      end
    end

    context 'validations' do
      subject(:result) { dummy_class.(input_params) }
      let(:string_param) { '4' }
      let(:integer_param) { 4 }
      let(:first) { '1' }
      let(:second) { '2' }
      let(:third) { '3' }
      let(:iterable_param) { [first, second, third] }
      let(:input_params) do
        {
          string_param: string_param,
          integer_param: integer_param,
          array_param: iterable_param
        }
      end
      let(:expected_result) { 42 }

      before do
        result
      end

      context 'validations' do
        let(:string_param) { false }
        let(:expected_errors) { { string_param: ['must be a string'] } }

        it 'sets errors' do
          expect(result.errors).not_to be_empty
          expect(result.errors).to match expected_errors
        end

        it 'fails' do
          expect(result).to be_failure
        end
      end

      context 'custom validations' do
        let(:string_param) { '3' }
        let(:expected_errors) { { invalid_string_param: ['Invalid string param'] } }

        it 'sets errors' do
          expect(result.errors).not_to be_empty
          expect(result.errors).to match expected_errors
        end

        it 'fails' do
          expect(result).to be_failure
        end
      end
    end
  end
end
