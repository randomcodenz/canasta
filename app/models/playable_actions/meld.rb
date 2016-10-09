module PlayableActions
  class Meld < PlayableAction
    attr_reader :meld_cards

    def initialize(meld_cards:)
      @meld_cards = meld_cards
    end

    def apply_to(game_engine:)
      game_engine.meld(:cards => meld_cards)
    end
  end
end
