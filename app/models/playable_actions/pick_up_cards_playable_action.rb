module PlayableActions
  class PickUpCardsPlayableAction < PlayableAction
    def apply_to(game_context:)
      game_context.pick_up_cards
    end
  end
end
