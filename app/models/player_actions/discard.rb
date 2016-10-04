# REVIEW Namespace these and playable actions
class Discard < PlayerAction
  validates :card_name, :presence => true

  def playable_action
    DiscardPlayableAction.new(:card_name => card_name)
  end
end
