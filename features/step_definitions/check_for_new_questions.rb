Given /^I specified tag "([^"]*)"$/ do |tag|
  @tag = tag
end

Given /^I have not checked for "([^"]*)" updates in the past$/ do |arg1|
  @questions_fake_data = []
  to_time = Time.now
  from_time = Time.utc(to_time.year-1, to_time.month)
  100.times do |i|
    @questions_data << {:id => i,
       :descr => "Question #{i}",
       :time_posted => Time.at((to_time.to_f - from_time.to_f)*rand + from_time.to_f) }
  end
end

When /^I check for new questions$/ do
  qm = QuestionsManager.new(@questions_fake_data)
  @new_questions = qm.get_new_questions
end

Then /^I receive (\d+) latest answers for specified tag$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^They are sorted from most to least recent$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I have checked for "([^"]*)" updates in the past$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Given /^There are (\d+) new questions for specified tag since my last check$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end