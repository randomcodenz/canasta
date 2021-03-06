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
    - Player is notified if the meld is not valid

  Scenario: Allow a player to select multiple cards
    Given I have started a game with 2 players
    And I have started a round
    When I view the round
    Then I can select multiple cards

  Scenario: Allow a player to table a meld
    Given I have started a game with 2 players
    And I have started a round
    And I am viewing the round
    And I have picked up 2 cards from stock
    When I meld "Ace of Spades", "Ace of Diamonds", "Two of Clubs"
    Then I can see the new meld of "Aces"
