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
    context 'when connection with api.stackexchange and jabber is fine' do
      it 'should send message to view' do
        creation_date = Time.new(2012, 2, 12, 19, 52, 35)
        questions = [OpenStruct.new(:tags => ['ruby', 'ruby-on-rails'], :creation_date => creation_date.to_i,
                     :question_id => 123, :title => 'Question 1')]

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
      it 'tries to reconnect 10 times when gets TimeoutError and if not, it raise error' do
        qm.should_receive(:get_new_questions).with(any_args).exactly(10).times.and_raise(::TimeoutError)
        view.should_receive(:send_msg_and_wait).with('Failed with TimeoutError', 61).once
        expect { subject.check_tag('ruby') }.to raise_error(::TimeoutError)
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