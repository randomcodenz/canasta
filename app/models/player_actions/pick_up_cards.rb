class PickUpCards < PlayerAction
  def playable_action
    PlayableActions::PickUpCardsPlayableAction.new
  end
end
