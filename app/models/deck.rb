require 'ostruct'

class Deck
  class << self
    def cards
      standard_deck + standard_deck
    end

    def shuffled_cards(seed = nil)
      seed ||= Random.new_seed
      cards.shuffle(:random => Random.new(seed))
    end

    private

    def standard_deck
      standard_deck_cards + standard_deck_jokers
    end

    def standard_deck_cards
      Card::SUITS.product(Card::RANKS).map do |pair|
        Card.new(:suit => pair[0], :rank => pair[1])
      end
    end

    def standard_deck_jokers
      Array.new(2) { Card.new(:rank => Card::JOKER) }
    end
  end
end
