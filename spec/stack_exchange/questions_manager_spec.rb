require 'spec_helper'

module StackExchange
  describe QuestionsManager do
    let(:requestor) { double('Rubyflow::Client').as_null_object }
    let(:current_time) { Time.new(2012, 1, 1).to_i }
    let(:manager) do
      StackExchange::QuestionsManager.new(requestor).tap { |manager| manager.stub(:current_time).and_return(current_time) }
    end

    describe '#set_last_tag_check' do
      it 'should set last tag check date' do
        unixtime = Time.now.to_i
        manager.set_last_tag_check 'ruby', unixtime
        manager.get_last_tag_check('ruby').should == unixtime
      end
    end

    describe '#get_last_tag_check' do
      it 'should return nil if no time were set for this tag before' do
        manager.get_last_tag_check('c++').should be_nil
      end
    end

    describe '#get_new_questions' do
      def expect_requestor_call with_params
        questions_received = Array.new(30)
        fake_result = OpenStruct.new({'total' => 100500, 'page' => 1, 'pagesize' => 30, 'items' => questions_received})
        questions = double('Questions')
        requestor.should_receive(:questions).and_return(questions)
        questions.should_receive(:fetch).with(with_params).and_return(fake_result)
        questions_received
      end

      it 'should receive new questions from requestor' do
        questions_received = expect_requestor_call({:pagesize => 30, :page => 1, :sort => 'creation', :tagged => 'ruby', :todate => current_time, :site => "stackoverflow"})

        result = manager.get_new_questions('ruby')

        result.should equal questions_received
      end

      it 'should set last tag check time after query for the tag' do
        expect_requestor_call({:pagesize => 30, :page => 1, :sort => 'creation', :tagged => 'ruby', :todate => current_time, :site => "stackoverflow"})

        manager.should_receive(:set_last_tag_check).with('ruby', kind_of(Numeric))
        manager.get_new_questions('ruby')
      end

      it 'should receive new questions from the last tag check time only' do
        prev_req_time = Time.now.to_i
        manager.set_last_tag_check('ruby', prev_req_time)
        expect_requestor_call({:pagesize => 30, :page => 1, :sort => 'creation', :tagged => 'ruby', :fromdate => prev_req_time, :todate => current_time, :site => "stackoverflow"})

        manager.get_new_questions('ruby')
      end
    end
  end
end
