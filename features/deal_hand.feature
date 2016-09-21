Feature: Deal a hand of canasta
  As a user
  I want to be dealt a hand
  so I can play a round of canasta

  Scenario: View the Canasta home page
    When I visit the home page
    Then I should see the heading "Welcome to Canasta"

  Scenario: Start a new game
    Given I am on the home page
    When I start a new game
    Then the new game is displayed
