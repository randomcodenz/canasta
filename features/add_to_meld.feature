Feature: Add to existing meld
  As a player
  I want to add cards to a meld I have already tabled
  So I can increase the value of the meld

  Scenario: Adding a natural and a wild card to an existing meld
    Given I am playing a round with 2 players and seed 1
    And I have picked up 2 cards from stock
    And I have melded "Six of Spades, Six of Diamonds and Two of Diamonds"
    And I am viewing the round
    When I add "Six of Clubs and Joker" to the "Sixes" meld
    Then I can see "Six of Clubs" in the "Sixes" meld
    And I can see "Joker" in the "Sixes" meld
