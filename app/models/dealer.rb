class Dealer
  PLAYERS = 2
  CARDS_PER_PLAYER = 15

  class << self
    def deal(shuffled_cards)
      player_hands = player_hands(shuffled_cards, CARDS_PER_PLAYER, PLAYERS)
      shuffled_cards -= player_hands.flatten
      discard_pile = discard_pile(shuffled_cards)
      stock = shuffled_cards - discard_pile

      OpenStruct.new(
        :player_hands => player_hands,
        :discard_pile => discard_pile,
        :stock => stock
      )
    end

    private

    def player_hands(shuffled_cards, cards_per_player, number_players)
      Array.new(cards_per_player) do |index|
        shuffled_cards.slice(index * number_players, number_players)
      end.transpose
    end

    def discard_pile(shuffled_cards)
      [shuffled_cards.first]
    end
  end
end
