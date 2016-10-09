module PlayerActions
  class Meld < PlayerAction
    has_many :meld_cards,
      -> { includes [:card_rank, :card_suit] },
      :class_name => :PlayerActionCard,
      :foreign_key => 'player_action_id'

    def playable_action
      cards_to_meld = meld_cards.map(&:to_card)
      PlayableActions::Meld.new(:meld_cards => cards_to_meld)
    end
  end
end
