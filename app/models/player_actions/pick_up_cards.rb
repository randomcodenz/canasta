class PickUpCards < PlayerAction
  include Playable

  def playable_actions
    [playable_action]
  end

  private

  def playable_action
    PickUpCardsPlayableAction.new
  end
end
