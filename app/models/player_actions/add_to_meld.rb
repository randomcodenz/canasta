module PlayerActions
  class AddToMeld < PlayerAction
    has_many :cards,
      -> { includes [:card_rank, :card_suit] },
      :class_name => :PlayerActionCard,
      :foreign_key => 'player_action_id'

    def playable_actions
      cards_to_add = cards.map(&:to_card)
      cards_to_add.map { |card| PlayableActions::AddToMeld.new(:meld_rank => target_meld_rank.to_sym, :card => card) }
    end
  end
end
