Feature: Find all stack exchange site user from specified country or city

  @completed
	Scenario: Find all users from Minsk on Stack Overflow with reputation higher than 45000
		Given I want to search on "Stack Overflow"
		And I want to search for users from "Minsk"
		And I want to search for users with reputation higher than 45000
		When I perform search for users
		Then I should see count of users
    And Among other I should see the following users:
		 | id | name |
		 | 137350 | Vladimir |
