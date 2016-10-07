Feature: Meld cards
    As a player
    I want to table a meld
    So I can scrore points

    Valid meld is defined as:
    - Minimum of 3 cards
    - All natural cards are of the same rank
    - Number of natural cards > number of wild cards

    Acceptance criteria:
    - Player can select card in their hand to form the meld
    - Player can table the meld if it is valid
    - Player is notified if the meld sis not valid

  Scenario: Allow a player to select multiple cards
    Given I have started a game with 2 players
    And I have started a round
    When I view the round
    Then I can select multiple cards
