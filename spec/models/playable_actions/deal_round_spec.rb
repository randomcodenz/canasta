require 'rails_helper'

module PlayableActions
  module DealRoundPlayableActionStubs
    class DummyGameEngine
      attr_reader :can_deal, :dealer, :deal_was_called

      def initialize(can_deal:)
        @can_deal = can_deal
      end

      def can_deal?
        can_deal
      end

      def deal(dealer:)
        @deal_was_called = true
        @dealer = dealer
        can_deal?
      end
    end
  end

  describe DealRound do
    let(:can_deal) { true }
    let(:deck_seed) { 959 }
    let(:game_engine) { DealRoundPlayableActionStubs::DummyGameEngine.new(:can_deal => can_deal) }

    subject(:playable_action) { DealRound.new(:deck_seed => deck_seed) }

    describe '#apply_to' do
      before { playable_action.apply_to(:game_context => game_engine) }

      it 'asks game context to deal a round' do
        expect(game_engine.deal_was_called).to be true
      end

      it 'supplied a dealer using a deck with the deck seed from the round' do
        expect(game_engine.dealer.deck.seed).to eq deck_seed
      end

      it 'returns the result of asking the game context to deal a round' do
        expect(playable_action.apply_to(:game_context => game_engine)).to eq can_deal
      end
    end
  end
end
