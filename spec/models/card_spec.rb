require 'rails_helper'

describe Card do
  describe '#<=>' do
    def queen_of_hearts
      Card.new(:suit => :hearts, :rank => :queen)
    end

    def joker
      Card.new(:rank => :joker)
    end

    it 'cards of the same rank and suit are equal' do
      expect(queen_of_hearts).to eq queen_of_hearts
    end

    it 'jokers are equal' do
      expect(joker).to eq joker
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
        end
      end

      # Array#sort uses <=> for comparison
      subject(:sorted_cards) { cards.to_a.sort }

      it 'cards are sorted by rank from ace..two' do
        expect(sorted_cards.map(&:rank)).to eq Card::RANKS
      end
    end

    context 'when comparing jokers to anything' do
      subject(:sorted_cards) { Deck.new.cards.to_a.sort }

      it 'jokers are always the lowest card' do
        expect(sorted_cards.last(4)).to eq [joker, joker, joker, joker]
      end
    end
  end

  describe '#to_s' do
    context 'when the card has a suit and rank' do
      subject(:card) { Card.new(:rank => :queen, :suit => :hearts) }

      it 'is formatted as <Rank> of <Suit>' do
        expect(card.to_s).to eq 'Queen of Hearts'
      end
    end

    context 'when the card is a joker' do
      subject(:card) { Card.new(:rank => :joker) }

      it 'returns Joker' do
        expect(card.to_s).to eq 'Joker'
      end
    end
  end

  describe '#from_s' do
    let(:card_name) { source_card.to_s }

    subject(:card) { Card.from_s(:card_name => card_name) }

    context 'when the card has a suit and rank' do
      let(:source_card) { Card.new(:rank => :queen, :suit => :hearts) }

      it 'parses the rank' do
        expect(card.rank).to eq source_card.rank
      end

      it 'parses the suit' do
        expect(card.suit).to eq source_card.suit
      end
    end

    context 'when the card is a joker' do
      let(:source_card) { Card.new(:rank => :joker) }

      it 'parses the rank' do
        expect(card.rank).to eq :joker
      end

      it 'sets the suit to none' do
        expect(card.suit).to eq :none
      end
    end
  end
end
