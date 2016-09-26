require 'rails_helper'

describe PlayerPresenter do
  let(:game) { Game.create! }
  let(:player1) { game.players.create!(:name => 'Player 1') }
  let(:deck) { Deck.new(:seed => BigIntRandomSeed.new_seed) }
  let(:dealer) { Dealer.new(:deck => deck, :number_of_players => 2) }
  let(:deal) { dealer.deal }

  subject(:presenter) { PlayerPresenter.new(:player => player1, :cards => deal.player_hands[0]) }

  it 'decorates a player' do
    expect(presenter).to eq player1
  end

  describe '#cards' do
    it 'returns the set of cards associated with the player' do
      expect(presenter.cards).to eq deal.player_hands[0]
    end
  end
end
