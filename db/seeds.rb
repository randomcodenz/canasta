Card::SUITS.each { |suit| CardSuit.create!(:suit => suit) }
CardSuit.create!(:suit => Card::NO_SUIT)

Card::RANKS.each { |rank| CardRank.create!(:rank => rank) }
CardRank.create!(:rank => Card::JOKER)
