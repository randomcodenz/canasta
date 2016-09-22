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
end
