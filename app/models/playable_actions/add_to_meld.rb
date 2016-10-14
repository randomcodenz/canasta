module PlayableActions
  class AddToMeld < PlayableAction
    attr_reader :card

    def initialize(card:)
      @card = card
    end

    def apply_to(game_engine:)
      game_engine.add_to_meld(:card => card)
    end
  end
end
