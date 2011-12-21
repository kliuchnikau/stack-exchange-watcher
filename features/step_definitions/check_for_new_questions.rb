class OutputSpy
  def messages
	  @messages ||= []
  end

  def puts msg
	  messages << msg
  end
end

def output
  @output ||= OutputSpy.new
end

Given /^I specified tag "([^"]*)"$/ do |tag|
  @tag = tag
end

Given /^I have not checked for "([^"]*)" updates in the past$/ do |tag|
  @questions_watcher = Watcher::QuestionsManager.new(output)
end

When /^I check for new questions$/ do
  @new_questions = @questions_watcher.get_new_questions @tag
end

Then /^I see a message "([^"]*)"$/ do |message|
  output.messages.should include message
end

Then /^I receive description of  (\d+) latest answers for specified tag$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^Answers are sorted from most to least recent$/ do
  pending # express the regexp above with the code you wish you had
end