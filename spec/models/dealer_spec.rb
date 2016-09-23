require 'rails_helper'

describe Dealer do
  describe '#deal' do
    let(:seed) { 969 }
    let(:shuffled_cards) { Deck.shuffled_cards(seed) }

    subject(:deal) { Dealer.deal(shuffled_cards) }

    context 'when dealing a 2 player game' do
      it 'deals 15 cards to each player' do
        expect(deal.player_hands.map(&:count)).to all eq 15
      end

      it 'the player hands are dealt in a round-robin manner' do
        expect(deal.player_hands.flatten).to match_array(shuffled_cards.take(30))
        expect(deal.player_hands).not_to eq shuffled_cards.take(30)
      end

      it 'creates the discard pile' do
        expect(deal.discard_pile).to eq shuffled_cards.slice(30, 1)
      end

      it 'creates the stock' do
        expect(deal.stock).to eq shuffled_cards.drop(31)
      end
    end
  end
end
