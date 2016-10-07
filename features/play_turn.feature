Feature: Play a simple turn
  As a player
  I want to play a turn
  So I can play my cards

  Scenario: Allow active player to pick up from stock
    Given I have started a game with 2 players
    And I have started a round
    And I am viewing the round
    When I pick up 2 cards from stock
    Then I should see 17 cards in my hand

  Scenario: Allow active player to discard
    Given I have started a game with 2 players
    And I have started a round
    And I am viewing the round
    And I have picked up 2 cards from stock
    When I discard the first card
    Then I should see 16 cards in my hand

  Scenario: Track active player
    Given I have started a game with 2 players
    And I have started a round
    When I view the round
    Then I can see the active player is "Player 1"

  Scenario: End active players turn when they discard
    Given I have started a game with 2 players
    And I have started a round
    And I am viewing the round
    And I have picked up 2 cards from stock
    When I discard the first card
    Then I can see the active player is "Player 2"
