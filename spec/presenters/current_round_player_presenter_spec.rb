require 'rails_helper'

describe CurrentRoundPlayerPresenter do
  let(:player_names) { %w(P1 P2) }
  let(:deck) { Deck.new(:seed => 989) }
  let(:dealer) { Dealer.new(:deck => deck) }
  let(:game_engine) do
    GameEngine.new.tap do |game|
      game.start_round(:player_names => player_names)
      game.deal(:dealer => dealer)
      game.pick_up_cards
    end
  end
  let(:player2) { game_engine.players[1] }

  subject(:presenter) { CurrentRoundPlayerPresenter.new(:player => player2) }

  it 'decorates a player context' do
    expect(presenter).to eq player2
  end

  describe '#hand_size' do
    it 'returns the number of cards in the players hand' do
      expect(presenter.hand_size).to eq player2.hand.size
    end
  end
end
