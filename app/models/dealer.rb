class Dealer
  CARDS_PER_PLAYER = { 2 => 15 }.freeze

  attr_reader :deck, :number_of_players

  def initialize(deck:, number_of_players:)
    @deck = deck
    @number_of_players = number_of_players
  end

  def deal
    shuffled_cards = deck.shuffled_cards
    cards_per_player = CARDS_PER_PLAYER[number_of_players]

    player_hands = player_hands(shuffled_cards, cards_per_player, number_of_players)
    discard_pile = discard_pile(player_hands.remaining_cards)

    OpenStruct.new(
      :player_hands => player_hands.player_hands,
      :discard_pile => discard_pile.discard_pile,
      :stock => discard_pile.remaining_cards
    )
  end

  private

  def player_hands(shuffled_cards, cards_per_player, number_players)
    player_hands = Array.new(cards_per_player) do |index|
      shuffled_cards.slice(index * number_players, number_players)
    end.transpose

    OpenStruct.new(
      :player_hands => player_hands,
      :remaining_cards => shuffled_cards - player_hands.flatten
    )
  end

  def discard_pile(shuffled_cards)
    discard_pile = [shuffled_cards.first]

    OpenStruct.new(
      :discard_pile => discard_pile,
      :remaining_cards => shuffled_cards - discard_pile
    )
  end
end
