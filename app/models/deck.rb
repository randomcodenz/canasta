class Deck
  SUITS = [:hearts, :diamonds, :spades, :clubs].freeze
  RANKS = [
    :ace, :two, :three, :four, :five, :six,
    :seven, :eight, :nine, :ten, :jack, :queen, :king
  ].freeze

  def self.cards
    standard_deck + standard_deck
  end

  def self.standard_deck
    standard_deck_cards + standard_deck_jokers
  end

  def self.standard_deck_cards
    SUITS.product(RANKS).map do |pair|
      Card.new(pair[0], pair[1])
    end
  end

  def self.standard_deck_jokers
    Array.new(2) { Card.new(nil, :joker) }
  end
end
