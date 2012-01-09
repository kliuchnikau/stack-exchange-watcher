require 'spec_helper'

describe View::Xmpp::QuestionsManagerView do
	let(:blather) { mock("Blather::Client").as_null_object }
	subject { View::Xmpp::QuestionsManagerView.new(blather, 'client_id', 'http://www.stackoverflow.com') }
	let(:questions) do
		[OpenStruct.new({"tags" => ["ruby", "rails", "google"], "title" => "Title of question 1",
										 "question_id" => 12345, "creation_date" => Time.new(2011, 12, 31, 14, 16, 56).to_i}),
		 OpenStruct.new({"tags" => ["ruby", "ruby-on-rails"], "title" => "Title of question 2",
										 "question_id" => 54321, "creation_date" => Time.new(2011, 12, 31, 15, 26, 44).to_i})]
	end

	describe '#show_list' do
		context 'when found new questions' do
			it 'should send message to client_id with new questions' do
				blather.should_receive(:status).and_return(:ready)
				blather.should_receive(:write).with(kind_of(Blather::Stanza::Message))

				subject.show_list(questions)
			end
		end
	end
end