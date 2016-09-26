require 'rails_helper'

describe GamePresenter do
  let(:game) do
    Game.create!.tap do |game|
      game.players.create!([{ :name => 'Player 1' }, { :name => 'Player 2' }])
    end
  end
  let(:deck) { Deck.new(:seed => Random.new_seed) }
  let(:dealer) { Dealer.new(:deck => deck, :number_of_players => 2) }
  let(:deal) { dealer.deal }

  subject(:presenter) { GamePresenter.new(:game => game, :game_state => deal) }

  it 'decorates a game' do
    expect(presenter).to eq game
  end

  describe '#round_in_progress?' do
    it 'returns true if the game has a round' do
      game.rounds.create!(:deck_seed => 999)
      expect(presenter.round_in_progress?).to be true
    end

    it 'returns false if game has no rounds' do
      expect(presenter.round_in_progress?).to be false
    end
  end

  describe '#round_over?' do
    it 'returns false if the game has a round' do
      game.rounds.create!(:deck_seed => 999)
      expect(presenter.round_over?).to be false
    end

    it 'returns true if game has no rounds' do
      expect(presenter.round_over?).to be true
    end
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

    it 'wraps each player in a player presenter' do
      expect(presenter.players.to_a).to all have_attributes(:class => PlayerPresenter)
    end

    it 'matches each player to their hand' do
      expect(presenter.players[0].cards).to eq deal.player_hands[0]
      expect(presenter.players[1].cards).to eq deal.player_hands[1]
    end

    context 'when no cards have been dealt' do
      subject(:presenter) { GamePresenter.new(:game => game, :game_state => nil) }

      it 'all players have an empty hand' do
        expect(presenter.players[0].cards).to be_empty
        expect(presenter.players[1].cards).to be_empty
      end
    end
  end
end
