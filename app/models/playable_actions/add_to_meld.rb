module PlayableActions
  class AddToMeld < PlayableAction
    attr_reader :cards, :meld_rank

    def initialize(meld_rank:, cards:)
      @meld_rank = meld_rank
      @cards = cards
    end

    def apply_to(game_engine:)
      game_engine.add_to_meld(:meld_rank => meld_rank, :cards => cards)
    end
  end
end
