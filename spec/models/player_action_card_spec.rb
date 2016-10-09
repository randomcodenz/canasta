require 'rails_helper'

describe PlayerActionCard, :type => :model do
  let(:rank) { :queen }
  let(:suit) { :hearts }
  let(:card) { Card.new(:rank => rank, :suit => suit) }
  let(:card_rank) { CardRank.where(:rank => 'queen').first }
  let(:card_suit) { CardSuit.where(:suit => 'hearts').first }

  subject(:player_action_card) { PlayerActionCard.new }

  it { is_expected.to belong_to(:card_rank) }

  it { is_expected.to belong_to(:card_suit) }

  describe '#rank=' do
    it 'sets card_rank to the related CardRank value' do
      player_action_card.rank = rank
      expect(player_action_card.card_rank).to eq card_rank
    end
  end

  describe '#rank' do
    it 'returns the CardRank rank as a symbol' do
      player_action_card.card_rank = card_rank
      expect(player_action_card.rank).to eq rank
    end
  end

  describe '#suit=' do
    it 'sets card_suit to the related CardSuit value' do
      player_action_card.suit = suit
      expect(player_action_card.card_suit).to eq card_suit
    end
  end

  describe '#suit' do
    it 'returns the CardSuit suit as a symbol' do
      player_action_card.card_suit = card_suit
      expect(player_action_card.suit).to eq suit
    end
  end

  describe '#to_card' do
    before do
      player_action_card.card_rank = card_rank
      player_action_card.card_suit = card_suit
    end

    it 'returns a card of the same rank and suit as the player action card' do
      expect(player_action_card.to_card).to eq card
    end
  end

  describe '#from_card' do
    subject(:new_card) { PlayerActionCard.from_card(:card => card) }

    it 'creates a new selected card' do
      expect(new_card.new_record?).to be true
    end

    it 'the player action card is populated with the correct card rank' do
      expect(new_card.card_rank).to eq card_rank
    end

    it 'the player action card is populated with the correct card suit' do
      expect(new_card.card_suit).to eq card_suit
    end
  end
end
