class Discard < PlayerAction
  include Playable

  validates :card_name, :presence => true

  def playable_actions
    [playable_action]
  end

  private

  def playable_action
    DiscardPlayableAction.new(:card_name => card_name)
  end
end
