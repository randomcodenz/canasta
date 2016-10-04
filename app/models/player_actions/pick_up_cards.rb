class PickUpCards < PlayerAction
  def playable_action
    PickUpCardsPlayableAction.new
  end
end
