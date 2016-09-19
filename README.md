# Canasta
Classic Canasta built with Rails.

## MVP
Enable two players to play a complete game of Canasta from initial deal to one player winning by scoring > 5000 points across multiple hands.

## Rules
### Cards
Two standard 52 card packs plus 4 jokers (108 cards in total).
Cards are scored as follows:
* Jokers : 50 points each
* A, 2 : 20 points each
* K-8 : 10 points each
* 7-4 : 5 points each
* Black 3 : 5 points each

A-4 are known as natural cards.
Jokers and 2s are known as wild cards.

3s have different rules for scoring and playing (see below)

### The Deal
Players are dealt 15 cards each.
The remainder of the cards are placed face down on the table (known as the stock).
The top card of the stock is turned over to form the discard pile.
- if this card is a red 3 or a wild card, the procedure is repeated until the top card of the discard is neither a red 3 or wild card

### Red 3s
Any red 3s dealt to the player must, on the players first turn, be placed face up on the table and draw a replacement from stock.
Any red 3s picked up from the stock must be immediately placed face up on the table and a replacement drawn from stock.
Any red 3s picked up from the discard pile must be immediately placed face up on the table - no replacement is drawn from stock.

### The Play
Players can either draw 2 cards from stock or pick up the discard pile if they can meld the top card (into an existing meld or by playing a new meld).
 - Players cannot pick up the discard pile if they only have 1 card in their hand and the discard pile contains a single card
Players can then meld as many or few cards as they like and their turn ends when they discard a single card. Discards must always be played form the hand and always face up onto the top card of the discard pile.

### Melds
Melds must be at least 3 cards comprising of:
* 2 - 8 natural cards of the same rank
* No more than 3 wild cards
* At least one more natural card than wild
* Black 3s cannot be melded except when going out

Players can meld from their hand or add cards into an existing meld already placed on the table as long as the result is always a valid meld. Players cannot add cards to an opponents meld.

### Canastas
A meld comprising 7 or more cards is known as a canasta. Canastas can be either natural or pure (containing no wilds), or mixed (containing wilds).

### Initial Meld
The minimum score required to make the first meld is determined by the players current score

Current Score | Minimum First Meld
------------- | ------------------
< 0 | 15
0 - 1495 | 50
1500 - 2995 | 90
3000+ | 120

Initial meld requirements can be met by multiple melds.
If the player picks up the discard pile to make the meld only the top card from the discard pile can count toward the minimum.
Bonuses for red 3s and canastas do not count towards the minimum.

### Freezing the Discard Pile
The discard pile is frozen:
* to any player that has not made their initial meld
* if a wild card or black three is discarded

### Unfreezing the Discared Pile
Can only be unfrozen by being taken.
Can only be taken when there is a natural card on the top of the discard pile.
Requires the player meld the top card on the discard with 2 natural cards (of the same rank) from their hand.

### Going Out
Going out requires the player to get rid of the last card in their hand by either discarding or melding.
Players cannot go out until they have 2 melds or they make 2 melds as part of going out.
A player going out is not required to discard.

### Concealed Hand
A player goes out "concealed" when they:
* meld their entire hand in a single turn
* meld at least one canasta 
* go out in the same turn

Player must meet the minimum meld requirements (without the canasta bonus) if they have take the discard pile, otherwise they are not required to meet the minimum meld requirements.

### Exhausting the Stock
If the last card drawn from stock is a red 3, the player places it face down on the table and play ends. The player drawing the red 3 may not meld or discard.

If the last card drawn from stock is not a red 3, play continues with each player taking the discard and melding it. Play ends when the player cannot take the discard or legally refuses to take it (1 card hand / 1 card discard).

### Scoring
Each deal is scored as follows:
Value of all the cards melded + bonuses - value of cards in hand

Bonus | Points
----- | ------
Natural canasta (each) | 500
Mixed canasta (each) | 300
Red 3 (each) | 100
All 4 red 3s | additional 400
Going out | 100
Going out concealed | additional 100

