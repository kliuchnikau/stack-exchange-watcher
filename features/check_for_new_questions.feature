Feature: Check for new questions by specified tag
  As a stack exchange site user
  I want to periodically check for new questions by specified tag
  So that I can track the new questions without visiting the stack exchange site and answer them as soon as they are posted.

  Background:
    Given I want to search on "Stack Overflow"

  @wip
  Scenario: First time for specified tag
    Given I specified tag "ruby"
    And I have not checked for "ruby" updates in the past
    When I check for new questions
    Then I see a message "Found 30 new answers"
    And I receive descriptions and links to 30 latest answers for specified tag

  @analyze
  Scenario: Second time for specified tag after small time period
    Given I specified tag "ruby"
    And I have checked for "ruby" updates in the past
    And There are 20 new questions for specified tag since my last check
    When I check for new questions
    Then I receive 20 latest answers for specified tag

  @analyze
  Scenario: Second time for specified tag after long time period
    Given I specified tag "ruby"
    And I have checked for "ruby" updates in the past
    And There are 100 new questions for specified tag since my last check
    When I check for new questions
    Then I receive 30 latest answers for specified tag