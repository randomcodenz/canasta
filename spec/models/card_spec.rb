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

    context 'when sorting a random collection of cards' do
      let(:card_data) do
        [
          [:ten, :hearts, 9],
          [:queen, :clubs, 4],
          [:nine, :hearts, 10],
          [:ace, :spades, 1],
          [:king, :spades, 3],
          [:three, :spades, 15],
          [:ace, :clubs, 2],
          [:jack, :spades, 5],
          [:ten, :spades, 8],
          [:three, :spades, 16],
          [:seven, :clubs, 12],
          [:seven, :clubs, 13],
          [:five, :clubs, 14],
          [:jack, :diamonds, 6],
          [:jack, :diamonds, 7],
          [:eight, :diamonds, 11]
        ]
      end
      let(:cards) do
        card_data.each_with_object([]) do |card_detail, array|
          rank = card_detail[0]
          suit = card_detail[1]
          position = card_detail[2]
          array << [position, Card.new(:rank => rank, :suit => suit)]
        end
      end
      let(:expected_sorted_cards) { cards.sort_by(&:first).map(&:last) }

      subject(:sorted_cards) { cards.map(&:last).sort }

      it 'they are sorted according to rank and then suit' do
        expect(sorted_cards).to match(expected_sorted_cards)
        expect(sorted_cards).to contain_exactly(*expected_sorted_cards)
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

  describe '#points' do
    let(:twenty_point_ranks) { [:ace, :two] }
    let(:ten_point_ranks) { [:king, :queen, :jack, :ten, :nine, :eight] }
    let(:five_point_ranks) { [:seven, :six, :five, :four, :three] }

    it 'jokers are worth 50 points' do
      joker = Card.new(:rank => :joker)
      expect(joker.points).to eq 50
    end

    it 'ace and two are worth 20 points each' do
      twenty_point_cards = twenty_point_ranks.map { |rank| Card.new(:rank => rank, :suit => :diamonds) }
      expect(twenty_point_cards.map(&:points)).to all eq 20
    end

    it 'king - eight are worth 10 points each' do
      ten_point_cards = ten_point_ranks.map { |rank| Card.new(:rank => rank, :suit => :hearts) }
      expect(ten_point_cards.map(&:points)).to all eq 10
    end

    it 'seven - three are worth 5 points each' do
      five_point_cards = five_point_ranks.map { |rank| Card.new(:rank => rank, :suit => :clubs) }
      expect(five_point_cards.map(&:points)).to all eq 5
    end
  end

  describe '#wild?' do
    it 'jokers are wild cards' do
      joker = Card.new(:rank => :joker)
      expect(joker.wild?).to be true
    end

    it 'twos are wild cards' do
      two = Card.new(:rank => :two, :suit => :clubs)
      expect(two.wild?).to be true
    end

    it 'no other ranks are wild' do
      non_wild_ranks = Card::RANKS - [:joker, :two]
      non_wild_cards = non_wild_ranks.map { |rank| Card.new(:rank => rank, :suit => :spades) }
      expect(non_wild_cards.map(&:wild?)).to all be false
    end
  end

  describe '#natural?' do
    it 'all ranks except wild cards are natural' do
      non_wild_ranks = Card::RANKS - [:joker, :two]
      non_wild_cards = non_wild_ranks.map { |rank| Card.new(:rank => rank, :suit => :hearts) }
      expect(non_wild_cards.map(&:natural?)).to all be true
    end

    it 'jokers are not natural' do
      joker = Card.new(:rank => :joker)
      expect(joker.natural?).to be false
    end

    it 'twos are not natural' do
      two = Card.new(:rank => :two, :suit => :diamonds)
      expect(two.natural?).to be false
    end
  end
end
