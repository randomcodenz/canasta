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

  Scenario: Start a game with 2 players
    Given I have started a game with 2 players
    When I view the game
    Then I should see 2 players

  Scenario: Start a new round
    Given I have started a game with 2 players
    And I am viewing the game
    When I start a new round
    Then I can see Round 1

  Scenario: Display players hands
    Given I have started a game with 2 players
    And I have started a round
    When I view the game
    Then I should see 2 players cards
