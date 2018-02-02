require 'spec_helper'

describe Watcher::QuestionsWatcher do
  let(:qm) do
    double('StackExchange::QuestrionsManager').as_null_object
  end

  let(:view) do
    double('View::Xmpp::QuestrionsManagerView').as_null_object
  end

  let(:subject) do
    Watcher::QuestionsWatcher.new(qm, view)
  end

  describe '#check_tag' do
    def fake_msg(creation_date)
      OpenStruct.new(:tags => ['ruby', 'ruby-on-rails'], :creation_date => creation_date.to_i,
                     :question_id => 123, :title => 'Question 1')
    end

    context 'when connection with api.stackexchange and jabber is fine' do
      it 'should send message to view' do
        creation_date = Time.new(2012, 2, 12, 19, 52, 35)
        questions = [fake_msg(creation_date)]

        qm.should_receive(:get_new_questions).with('ruby').and_return(questions)
        expected_msg = "\nhttp://www.stackoverflow.com/questions/123/ \"Question 1\" [ruby, ruby-on-rails] (19:52:35)"
        view.should_receive(:send_msg_and_wait).with(expected_msg, 61)

        subject.check_tag('ruby')
      end

      it 'sends unexpected error to the view' do
        qm.should_receive(:get_new_questions).and_raise NotImplementedError.new 'Test error'
        view.should_receive(:send_msg_and_wait).with(/^NotImplementedError - Test error\n/, 61)
        expect { subject.check_tag('ruby') }.to raise_error NotImplementedError
      end
    end

    context 'when connection is broken' do
      it 'tries to reconnect 10 times when gets Timeout::Error and if not, it raise error' do
        qm.should_receive(:get_new_questions).with(any_args).exactly(10).times.and_raise(::Timeout::Error)
        view.should_receive(:send_msg_and_wait).with('Failed with Timeout::Error', 61).once
        expect { subject.check_tag('ruby') }.to raise_error(::Timeout::Error)
      end
    end

    context 'when logger specified' do
      it 'should log result received from questions manager to logger' do
        logger = double('logger')
        subj =  Watcher::QuestionsWatcher.new(qm, view, logger)

        qm.stub(:get_new_questions).and_return Array.new(3, fake_msg(Time.now))
        logger.should_receive(:info).with("Found 3 results for 'ruby' tag")

        subj.check_tag('ruby')
      end
    end
  end

  describe '#watch_tags' do
    it 'should continuously watch tags and stop when receives Ctrl+C' do
      subject.should_receive(:check_tag).with('ruby').exactly(2).times
      subject.should_receive(:check_tag).with('ruby').and_raise(::Interrupt)
      subject.watch_tags('ruby')
    end
  end
end
