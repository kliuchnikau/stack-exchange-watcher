def user_filter
	@filter ||= {}
end

Given /^I want to search on "([^"]*)"$/ do |site|
	@host = site =~ /Stack Overflow/ ? 'http://api.stackoverflow.com' : ''
  require 'rubyoverflow'
  @requestor = Rubyoverflow::Client.new({:host => @host, :version => '1.1'})
end

Given /^I want to search for users from "([^"]*)"$/ do |country|
	@country = country
end

Given /^I want to search for users with reputation higher than (\d+)$/ do |reputation|
	@min_reputation = reputation
end

When /^I perform search for users$/ do
	users = StackExchange::UserManager.new(@requestor).find_from_country(@country, @min_reputation.to_i)
  View::Cli::UserManagerView.new(output, @host).show_list(users)
end

Then /^Among other I should see the following users:$/ do |id_name_table|
  #test_users = id_name_table.hashes
  #test_users.each { |hash|
  #  @users.find_all {|u| u.user_id.to_i == hash[:id].to_i }.should have(1).user
  #}

  #@users.count.should be >= test_users.count

  output.should have_at_least(test_users.count).messages

  test_users = id_name_table.hashes
  test_users.each { |hash|
    output.messages.find_all { |msg| msg =~ %r%/Id: #{hash[:id]}, Name: .+, Reputation: \d+, Link: http://www.stackoverflow.com/users/\d+/% }.should have(1).message
  }
end

Then /^I should see count of users$/ do
  output.messages.find {|msg| msg =~ /^Found \d+ users/}.should have(1).message
end