class DealRoundPlayableAction < PlayableAction
  attr_reader :deck_seed

  def initialize(deck_seed:)
    @deck_seed = deck_seed
  end

  def apply_to(game_context:)
    deck = Deck.new(:seed => deck_seed)
    dealer = Dealer.new(:deck => deck)
    game_context.deal(:dealer => dealer)
  end
end
