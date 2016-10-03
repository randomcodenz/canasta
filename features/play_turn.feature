Feature: Play a simple turn
  As a player
  I want to play a turn
  So I can play my cards

  Scenario: Allow current player to pick up from stock
    Given I have started a game with 2 players
    And I have started a round
    And I am viewing the round
    When I pick up 2 cards from stock
    Then I should see 17 cards in my hand
