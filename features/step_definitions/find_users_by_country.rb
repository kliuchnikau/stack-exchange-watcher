def filter
	@filter ||= {}
end

Given /^I want to search for users of "([^"]*)"$/ do |site|
	filter[:site] = site
end

Given /^I want to search for users from "([^"]*)"$/ do |country|
	filter[:country] = country
end

Given /^I want to search for users with reputation higher than (\d+)$/ do |reputation|
	filter[:min_reputation] = reputation
end

When /^I perform search for new user$/ do
	@users = StackExchange::Users.find(filter)
end

Then /^Among other I should get the following users:$/ do |id_name_table|
	# table is a Cucumber::Ast::Table
	pending # express the regexp above with the code you wish you had
end

Then /^All these users are sorted from highest reputation to lowest$/ do
	pending # express the regexp above with the code you wish you had
end