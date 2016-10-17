module PlayableActions
  class AddToMeld < PlayableAction
    attr_reader :card

    def initialize(meld_rank:, card:)
      @meld_rank = meld_rank
      @card = card
    end

    def apply_to(game_engine:)
      game_engine.add_to_meld(:meld_rank => @meld_rank, :card => card)
    end
  end
end
