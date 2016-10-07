require 'rails_helper'

describe CurrentRoundActivePlayerPresenter do
  let(:game) do
    Game.create! do |game|
      game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
      game.rounds.new(:deck_seed => 989)
      game.rounds.new(:deck_seed => 959)
    end
  end
  let(:current_round) { game.rounds.last }
  let(:deck) { Deck.new(:seed => current_round.deck_seed) }
  let(:dealer) { Dealer.new(:deck => deck) }
  let(:game_engine) do
    GameEngine.new.tap do |engine|
      engine.start_round(:player_names => game.players.map(&:name))
      engine.deal(:dealer => dealer)
    end
  end
  let(:player1) { game_engine.active_player }

  subject(:presenter) { CurrentRoundActivePlayerPresenter.new(:player => player1, :round => current_round) }

  it 'decorates a player context' do
    expect(presenter).to eq player1
  end

  describe '#hand_size' do
    it 'returns the number of cards in the players hand' do
      expect(presenter.hand_size).to eq player1.hand.size
    end
  end
end
