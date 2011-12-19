Given /^I specified tag "([^"]*)"$/ do |tag|
  @tag = tag
end

Given /^I have not checked for "([^"]*)" updates in the past$/ do |tag|
  @questions_data = []
  to_time = Time.now
  from_time = Time.utc(to_time.year-1, to_time.month)
  100.times do
    @questions_data << { :time_posted => Time.at((to_time.to_f - from_time.to_f)*rand + from_time.to_f),
       :tags => [tag]
    }
  end
end

When /^I check for new questions$/ do
  watcher = QuestionsWatcher.new(@questions_data)
  @new_questions = watcher.get_new_questions @tag
end

Then /^I receive (\d+) latest answers for specified tag$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^Answers are sorted from most to least recent$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I have checked for "([^"]*)" updates in the past$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Given /^There are (\d+) new questions for specified tag since my last check$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end