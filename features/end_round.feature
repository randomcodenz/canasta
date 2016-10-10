Feature: End round
  As a player
  I want the round to end when the stock has been exhausted
  So I can start a new round

  Acceptance criteria:
  - Round ends when a player discards and there are no cards left in the stock
  - Display a "round over" message when the round is over
  - Allow players to start a new round

  Scenario: Round ends when player discards and stock is empty
    Given I have started a game with 2 players
    And I have started a round
    And I have picked up the last cards from stock
    And I am viewing the round
    When I discard the first card
    Then I can see the round is over
