class PlayerActionCard < ActiveRecord::Base
  belongs_to :card_rank
  belongs_to :card_suit

  def rank
    card_rank.rank.to_sym
  end

  def rank=(rank)
    self.card_rank = CardRank.from_rank(:rank => rank)
  end

  def suit
    card_suit.suit.to_sym
  end

  def suit=(suit)
    self.card_suit = CardSuit.from_suit(:suit => suit)
  end

  def to_card
    Card.new(:rank => rank, :suit => suit)
  end

  def self.from_card(card:)
    PlayerActionCard.new do |selected_card|
      selected_card.rank = card.rank
      selected_card.suit = card.suit
    end
  end
end
