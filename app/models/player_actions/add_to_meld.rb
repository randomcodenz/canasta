module PlayerActions
  class AddToMeld < PlayerAction
    has_many :cards,
      -> { includes [:card_rank, :card_suit] },
      :class_name => :PlayerActionCard,
      :foreign_key => 'player_action_id'

    def playable_action
      cards_to_add = cards.map(&:to_card)
      PlayableActions::AddToMeld.new(:meld_rank => target_meld_rank.to_sym, :cards => cards_to_add)
    end
  end
end
