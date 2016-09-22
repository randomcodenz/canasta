require 'rails_helper'

describe Deck do
  describe '#cards' do
    let(:ranks) { cards.map(&:rank) }
    let(:jokers) { ranks.select { |rank| rank == :joker } }
    let(:standard_ranks) { ranks - jokers }

    subject(:cards) { Deck.cards }

    it 'returns 108 cards' do
      expect(cards).to have_attributes(:count => 108)
    end

    it 'contains 4 jokers' do
      expect(jokers).to contain_exactly(*Array.new(4) { :joker })
    end

    it 'contains 8 cards of each standard rank' do
      expect(standard_ranks.group_by { |rank| rank }.values)
        .to all have_attributes(:count => 8)
    end

    it 'contains all of the standard ranks' do
      expect(standard_ranks.group_by { |rank| rank }.keys)
        .to have_attributes(:count => 13)
    end
  end

  describe '#shuffled_cards' do
    let(:seed) { nil }

    subject(:shuffled_cards) { Deck.shuffled_cards(seed) }

    it 'shuffled cards are not in the default cards order' do
      expect(shuffled_cards).not_to eq Deck.cards
    end

    context 'with a given seed' do
      let(:seed) { 10 }

      it 'shuffled_cards always shuffle in the same order' do
        expect(shuffled_cards).to eq Deck.shuffled_cards(seed)
      end
    end
  end
end
