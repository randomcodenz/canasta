require 'rails_helper'

describe Meld do
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

  def make_meld(card_details)
    meld_cards = card_details.map { |rank, suit| Card.new(:rank => rank, :suit => suit) }
    Meld.new(:cards => meld_cards)
  end

  describe '#rank' do
    it 'is the rank of the natural cards in the meld' do
      expect(wild_meld.rank).to eq :queen
    end
  end

  describe '#wild?' do
    it 'is true if there are any wild cards in the meld' do
      expect(wild_meld.wild?).to be true
    end

    it 'is false if there are no wild cards in the meld' do
      expect(natural_meld.wild?).to be false
    end
  end

  describe '#natural?' do
    it 'is true if all the cards are natural cards' do
      expect(natural_meld.natural?).to be true
    end

    it 'is false if any of the cards are wild' do
      expect(wild_meld.natural?).to be false
    end
  end

  describe '#bonus_points' do
    it 'returns 500 for a natural meld' do
      expect(natural_meld.bonus_points).to eq 500
    end

    it 'returns 300 for a wild meld' do
      expect(wild_meld.bonus_points).to eq 300
    end
  end

  describe '#points' do
    it 'returns the sum of points for each card in the meld + the bonus' do
      expect(wild_meld.points).to eq 20 + 50 + 10 + 10 + 10 + 300
      expect(natural_meld.points).to eq 10 + 10 + 10 + 500
    end
  end
end
