require 'spec_helper'

describe View::Cli::QuestionsManagerView do
  let(:output) { double('stdout').as_null_object }
  let(:questions) do
    [OpenStruct.new({"tags" => [ "ruby", "rails", "google"], "title" => "Title of question 1",
                     "question_id" => 12345, "creation_date" => Time.new(2011, 12, 31, 14, 16, 56).to_i}),
    OpenStruct.new({"tags" => [ "ruby", "ruby-on-rails"], "title" => "Title of question 2",
                    "question_id" => 54321, "creation_date" => Time.new(2011, 12, 31, 15, 26, 44).to_i})]
  end
  subject { View::Cli::QuestionsManagerView.new('http://www.stackoverflow.com', output) }

  describe '#show_list' do
    context 'when there are several questions to show' do
      it 'prints found questions line by line' do
        output.should_receive(:puts)
          .with("http://www.stackoverflow.com/questions/12345/ \"Title of question 1\" [ruby, rails, google] (14:16:56)")

        output.should_receive(:puts)
          .with("http://www.stackoverflow.com/questions/54321/ \"Title of question 2\" [ruby, ruby-on-rails] (15:26:44)")

        subject.show_list questions
      end
    end

    context 'when there is nothing to show' do
      it 'shows nothing' do
        output.should_not_receive(:puts)

        subject.show_list nil
        subject.show_list []
      end
    end
  end
end