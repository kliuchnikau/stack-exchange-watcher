require 'spec_helper'

module StackExchange
  describe QuestionsManager do
    let(:requestor) { double('Rubyflow::Client').as_null_object }
    before(:each) { @manager = StackExchange::QuestionsManager.new(requestor) }

    describe '#set_last_tag_check' do
      it 'should set last tag check date' do
        unixtime = Time.now.to_i
        @manager.set_last_tag_check 'ruby', unixtime
        @manager.get_last_tag_check('ruby').should == unixtime
      end
    end

    describe '#get_last_tag_check' do
      it 'should return nil if no time were set for this tag before' do
        @manager.get_last_tag_check('c++').should be_nil
      end
    end

    describe '#get_new_questions' do
      it 'should receive new questions from requestor' do
        fake_result = OpenStruct.new({'total' => 100500, 'page' => 1, 'pagesize' => 30, 'questions' => Array.new(30) })
        questions = mock('Questions')
        requestor.should_receive(:questions).and_return(questions)
        questions.should_receive(:fetch).with(pagesize: 30, page: 1, sort: 'creation', tagged: 'ruby').and_return(fake_result)  # fromdate: unixtime

        @manager.get_new_questions('ruby')
      end
    end
  end
end