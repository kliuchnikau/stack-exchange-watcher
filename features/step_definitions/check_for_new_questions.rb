def last_tag_check
  @last_tag_check ||= {}
end

Given /^I specified tag "([^"]*)"$/ do |tag|
  @tag = tag
end

Given /^I have not checked for "([^"]*)" updates in the past$/ do |tag|
  last_tag_check[tag] = nil
end

When /^I check for new questions$/ do
  questions_watcher = StackExchange::QuestionsManager.new(@requestor)
  last_tag_check.each { |tag, unixtime| questions_watcher.set_last_tag_check(tag, unixtime) }
  new_questions = questions_watcher.get_new_questions @tag

  View::Cli::QuestionsManagerView.new(site(@site), output).show_list(new_questions)
end

Then /^I see a message "([^"]*)"$/ do |message|
  output.messages.should include message
end

Then /^I receive descriptions and links to (\d+) latest answers for specified tag$/ do |count|
  links = output.messages.find_all {|msg| msg =~ %r%http://www.stackoverflow.com/questions/\d+/ ".+" \[.*#{@tag}.*\] \(\d{2}:\d{2}:\d{2}\)% }
  links.should have(count).items
end
