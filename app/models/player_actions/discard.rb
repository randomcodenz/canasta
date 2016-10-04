module PlayerActions
  class Discard < PlayerAction
    validates :card_name, :presence => true

    def playable_action
      PlayableActions::DiscardPlayableAction.new(:card_name => card_name)
    end
  end
end
