require 'rails_helper'

describe PlayerContext do
  let(:player_hand_cards) { [[:three, :clubs], [:six, :hearts], [:jack, :diamonds]] }
  let(:player_hand) { player_hand_cards.map { |rank, suit| Card.new(:rank => rank, :suit => suit) } }
  let(:wild_meld_cards) do
    [
      [:two, :spades],
      [:joker, :none],
      [:queen, :hearts],
      [:queen, :diamonds],
      [:queen, :hearts]
    ]
  end
  let(:natural_meld_cards) { [[:queen, :hearts], [:queen, :diamonds], [:queen, :hearts]] }
  let(:wild_meld) { make_meld(wild_meld_cards) }
  let(:natural_meld) { make_meld(natural_meld_cards) }

  subject(:player_context) do
    PlayerContext.new(:index => 1, :name => 'P1').tap do |player|
      player.hand = player_hand
      player.melds << wild_meld
      player.melds << natural_meld
    end
  end

  def make_meld(card_details)
    meld_cards = card_details.map { |rank, suit| Card.new(:rank => rank, :suit => suit) }
    Meld.new(:cards => meld_cards)
  end

  describe '#points_in_hand' do
    it 'sums the value of all the cards in the players hand' do
      expect(player_context.points_in_hand).to eq 5 + 5 + 10
    end
  end

  describe '#meld_points' do
    it 'sums the value of all the melds the player has tabled' do
      expect(player_context.meld_points).to eq 400 + 530
    end
  end

  describe '#round_score' do
    it 'subtracts the points in hand from meld points' do
      expect(player_context.round_score).to eq 930 - 20
    end
  end
end
