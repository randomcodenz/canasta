require 'rails_helper'

describe CardSuit, :type => :model do
  let(:card_suits) { Card::SUITS + [Card::NO_SUIT] }

  subject { CardSuit.new(:suit => :spades) }

  it { is_expected.to validate_presence_of(:suit) }

  it { is_expected.to validate_length_of(:suit).is_at_most(10) }

  it do
    is_expected.to validate_uniqueness_of(:suit)
      .case_insensitive
  end

  it 'card suits contains all of the suits and "no suit"' do
    expect(CardSuit.all.map(&:suit).map(&:to_sym)).to match(card_suits)
  end

  describe '#from_suit' do
    let(:suit) { :hearts }

    it 'returns the CardSuit that matches the specified symbol' do
      expect(CardSuit.from_suit(:suit => suit).suit).to eq suit.to_s
    end
  end
end
