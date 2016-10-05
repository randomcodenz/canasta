module PlayableActions
  class PickUpCards < PlayableAction
    def apply_to(game_engine:)
      game_engine.pick_up_cards
    end
  end
end
