Feature: Find all stack exchange site user from specified country or city

	@wip
	Scenario: Find all users from Minsk on Stack Overflow with reputation more than 1000
		Given I want to search on "Stack Overflow"
		And I want to search for users from "Minsk"
		And I want to search for users with reputation higher than 1000
		When I perform search for users
		Then Among other I should get the following users:
		 | id | name |
		 | 137350 | vladimir |
		 | 158689 | alex-kliuchnikau |
		 | 125805 | neutrino |
		 | 331488 | michael-sagalovich |
		And All these users are sorted from highest reputation to lowest