module PlayableActions
  class Discard < PlayableAction
    attr_reader :card_name, :card

    def initialize(card_name:)
      @card_name = card_name
      @card = Card.from_s(:card_name => card_name)
    end

    def apply_to(game_engine:)
      game_engine.discard(:card => card)
    end
  end
end
