require 'spec_helper'

module StackExchange
  describe Questions do
    let(:output) { double( 'stdout').as_null_object }
    let(:manager) { StackExchange::Questions.new(output) }

    describe '#get_new_questions' do
      it 'should show found messages count in the output'
    end
  end
end