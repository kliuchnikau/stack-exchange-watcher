require 'spec_helper'

describe Watcher::QuestionsWatcher do
  describe '#watch_tags' do
    let(:qm) do
      double('StackExchange::QuestrionsManager').as_null_object
    end

    let(:view) do
      double('View::Xmpp::QuestrionsManagerView').as_null_object
    end

    #before(:each) do
    #  requestor.should_receive(:questions).and_return(questions)
    #end
  end
end