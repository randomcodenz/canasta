require 'rails_helper'

describe CurrentRoundGamePresenter do
  let(:game) do
    Game.create! do |game|
      game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
      # Don't need a round at the moment but when we do create it here
    end
  end
  let(:deck) { Deck.new(:seed => Random.new_seed) }
  let(:dealer) { Dealer.new(:deck => deck, :number_of_players => 2) }
  let(:deal) { dealer.deal }

  subject(:presenter) { CurrentRoundGamePresenter.new(:game => game, :game_state => deal) }

  it 'decorates a game' do
    expect(presenter).to eq game
  end

  describe '#current_round_number' do
    it 'returns the number of rounds' do
      expect(presenter.current_round_number).to eq game.rounds.count
    end
  end

  describe '#players' do
    it 'decorates all of the players' do
      expect(presenter.players.to_a). to eq game.players.to_a
    end

    it 'wraps each player in a current round player presenter' do
      expect(presenter.players.to_a).to all have_attributes(:class => CurrentRoundPlayerPresenter)
    end

    it 'matches each player to their hand' do
      expect(presenter.players[0].cards).to eq deal.player_hands[0]
      expect(presenter.players[1].cards).to eq deal.player_hands[1]
    end
  end

  describe '#discard_pile_top_card' do
    it 'returns the top card of the discard pile' do
      expect(presenter.discard_pile_top_card).to eq deal.discard_pile.last
    end
  end

  describe '#discard_pile_size' do
    it 'returns the number of cards in the discard pile' do
      expect(presenter.discard_pile_size).to eq 1
    end
  end

  describe '#stock_size' do
    it 'returns the number of cards in the stock' do
      expect(presenter.stock_size).to eq 77
    end
  end
end
