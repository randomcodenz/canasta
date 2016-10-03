require 'rails_helper'

describe CurrentRoundPlayerPresenter do
  let(:game) { Game.create! }
  let(:player1) { game.players.create!(:name => 'Player 1') }
  let(:deck) { Deck.new(:seed => 989) }
  let(:dealer) { Dealer.new(:deck => deck) }
  let(:deal) { dealer.deal(:number_of_players => 2) }

  subject(:presenter) { CurrentRoundPlayerPresenter.new(:player => player1, :hand => deal.player_hands[0]) }

  it 'decorates a player' do
    expect(presenter).to eq player1
  end

  describe '#hand' do
    it 'returns the current players hand of card' do
      expect(presenter.hand).to eq deal.player_hands[0]
    end
  end

  describe '#hand_size' do
    it 'returns the number of cards in the current players hand' do
      expect(presenter.hand_size).to eq deal.player_hands[0].size
    end
  end
end
