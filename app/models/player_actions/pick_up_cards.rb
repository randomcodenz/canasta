module PlayerActions
  class PickUpCards < PlayerAction
    def playable_action
      PlayableActions::PickUpCards.new
    end
  end
end
