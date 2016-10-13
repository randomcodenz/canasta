Feature: Add to existing meld
  As a player
  I want to add cards to a meld I have already tabled
  So I can increase the value of the meld

  Scenario: Add natural card to existing meld
    Given I am playing a round with 2 players
    And I have melded "King of Hearts, King of Diamonds and Two of Clubs"
    And I am viewing the round
    When I add "King of Clubs" to the meld
    Then I can see "King of Clubs" in the meld
