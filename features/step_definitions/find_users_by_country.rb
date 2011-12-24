def user_filter
	@filter ||= {}
end

Given /^I want to search on "([^"]*)"$/ do |site|
	host = site =~ /Stack Overflow/ ? 'http://api.stackoverflow.com' : ''
  require 'rubyoverflow'
  @requestor = Rubyoverflow::Client.new({:host => host, :version => '1.1'})
end

Given /^I want to search for users from "([^"]*)"$/ do |country|
	@country = country
end

Given /^I want to search for users with reputation higher than (\d+)$/ do |reputation|
	@min_reputation = reputation
end

When /^I perform search for users$/ do
	@users = StackExchange::UserManager.new(@requestor).find_from_country(@country, @min_reputation.to_i)
end

Then /^Among other I should get the following users:$/ do |id_name_table|
  test_users = id_name_table.hashes
  test_users.each { |hash|
    @users.find_all {|u| u.user_id.to_i == hash[:id].to_i }.should have(1).user
  }

  @users.count.should be >= test_users.count
end