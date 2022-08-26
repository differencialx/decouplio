# frozen_string_literal: true

RSpec.describe 'Decouplio::ActionStatePrinter' do
  subject(:meta_store) { Decouplio::ActionStatePrinter.call(action) }

  include_context 'with basic spec setup'

  describe '.call' do
    let(:action_block) { when_action_meta_store }
    let(:input_params) do
      {
        s1: s1
      }
    end
    let(:expected_print_message) do
      <<~EXPECTED_MESSAGE
        Result: #{expected_result}
        RailwayFlow:
          #{expected_flow}
        Context:
          #{expected_context}
        #{expected_metastore}
      EXPECTED_MESSAGE
    end
    let(:expected_metastore) do
      <<~METASTORE
        Status: 400
        Errors:
          :error1 => ["Message 1"]
          :error2 => ["Message 2"]
      METASTORE
    end

    context 'when step_one success' do
      let(:s1) { -> { true } }
      let(:expected_result) { 'success' }
      let(:expected_flow) do
        'step_one -> step_two -> step_three'
      end
      let(:expected_context) do
        ":s1 => #{s1.inspect}\n  "\
          ":step_one => true\n  "\
          ":step_two => \"Success\"\n  "\
          ':step_three => "Success"'
      end

      it 'prints correct message' do
        expect(action.inspect).to eq expected_print_message
      end
    end

    context 'when step_one failure' do
      let(:s1) { -> { false } }
      let(:expected_result) { 'failure' }
      let(:expected_flow) do
        'step_one'
      end
      let(:expected_context) do
        ":s1 => #{s1.inspect}\n  "\
          ':step_one => false'
      end

      it 'prints correct message' do
        expect(action.inspect).to eq expected_print_message
      end
    end
  end
end
