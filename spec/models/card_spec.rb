require 'rails_helper'

describe Card do
  describe '#<=>' do
    it 'cards of the same rank and suit are equal' do
      expect(Card.new(:suit => :hearts, :rank => :queen))
        .to eq Card.new(:suit => :hearts, :rank => :queen)
    end

    it 'jokers are equal' do
      expect(Card.new(:rank => :joker))
        .to eq Card.new(:rank => :joker)
    end

    context 'when comparing cards of the same rank' do
      let(:cards) do
        Card::SUITS.map { |suit| Card.new(:suit => suit, :rank => :jack) }
      end

      # Array#sort uses <=> for comparison
      subject(:sorted_cards) { cards.to_a.sort }

      it 'cards are sorted by suit in spades, hearts, diamonds, clubs order' do
        expect(sorted_cards.map(&:suit)).to eq Card::SUITS
      end
    end

    context 'when comparing cards of the same suit' do
      let(:cards) do
        Card::RANKS.map do |rank|
          Card.new(:suit => :diamonds, :rank => rank)
        end | [Card.new(:rank => Card::JOKER)]
      end

      # Array#sort uses <=> for comparison
      subject(:sorted_cards) { cards.to_a.sort }

      it 'cards are sorted by rank from ace..two then joker' do
        expect(sorted_cards.map(&:rank)).to eq Card::RANKS | [Card::JOKER]
      end
    end
  end
end
