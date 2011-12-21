require 'spec_helper'

module Watcher
  describe QuestionsManager do
    let(:output) { double( 'stdout').as_null_object }
    let(:manager) { Watcher::QuestionsManager.new(output) }

    describe '#get_new_questions' do
      it 'should show found messages count in the output'
    end
  end
end