def user_filter
	@filter ||= {}
end

Given /^I want to search on "([^"]*)"$/ do |site|
  require 'rubyoverflow'
  @requestor = Rubyoverflow::Client.config do |options|
    options.host = 'http://api.stackoverflow.com' if site =~ /Stack Overflow/
    options.version = '1.1'
  end
end

Given /^I want to search for users from "([^"]*)"$/ do |country|
	@country = country
end

Given /^I want to search for users with reputation higher than (\d+)$/ do |reputation|
	@min_reputation = reputation
end

When /^I perform search for users$/ do
	@users = StackExchange::UserManager.new(@requestor).find_from_country(@country, @min_reputation)
end

Then /^Among other I should get the following users:$/ do |id_name_table|
	test_users = id_name_table.hashes
  test_users.each { |hash|
    @users.find_all {|u| u.id == hash[:id] && u.name == hash[:name] }.should have(1).user
  }

  @users.count.should be > test_users.count
end

Then /^All these users are sorted from highest reputation to lowest$/ do
	pending # express the regexp above with the code you wish you had
end