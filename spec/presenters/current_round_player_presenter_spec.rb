require 'rails_helper'

describe CurrentRoundPlayerPresenter do
  let(:game) { Game.create! }
  let(:player1) { game.players.create!(:name => 'Player 1') }
  let(:deck) { Deck.new(:seed => 989) }
  let(:dealer) { Dealer.new(:deck => deck) }
  let(:deal) { dealer.deal(:number_of_players => 2) }

  subject(:presenter) { CurrentRoundPlayerPresenter.new(:player => player1, :cards => deal.player_hands[0]) }

  it 'decorates a player' do
    expect(presenter).to eq player1
  end

  describe '#cards' do
    it 'returns the set of cards associated with the player' do
      expect(presenter.cards).to eq deal.player_hands[0]
    end
  end
end
