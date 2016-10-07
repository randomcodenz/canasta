module PlayableActions
  class DealRound < PlayableAction
    attr_reader :deck_seed

    def initialize(deck_seed:)
      @deck_seed = deck_seed
    end

    def apply_to(game_engine:)
      deck = Deck.new(:seed => deck_seed)
      dealer = Dealer.new(:deck => deck)
      game_engine.deal(:dealer => dealer)
    end
  end
end
