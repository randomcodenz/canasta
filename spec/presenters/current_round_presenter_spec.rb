require 'rails_helper'

describe CurrentRoundPresenter do
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

  subject(:presenter) do
    CurrentRoundPresenter.new(
      :current_round => current_round,
      :game_state => game_engine
    )
  end

  it 'decorates a round' do
    expect(presenter).to eq current_round
  end

  describe '#current_round_number' do
    it 'returns the number of rounds' do
      expect(presenter.current_round_number).to eq game.rounds.count
    end
  end

  describe '#players' do
    it 'decorates all of the player contexts' do
      expect(presenter.players.to_a). to eq game_engine.players.to_a
    end

    context 'when the round is still playable' do
      it 'wraps each player except the active in a current round player presenter' do
        expect(presenter.players.drop(1).to_a).to all have_attributes(:class => CurrentRoundPlayerPresenter)
      end

      it 'wraps the active player in a current round active player presenter' do
        expect(presenter.players[0]).to have_attributes(:class => CurrentRoundActivePlayerPresenter)
      end
    end

    context 'when the round is over' do
      before do
        # Play the game until stock is empty
        until game_engine.stock.empty?
          game_engine.pick_up_cards
          game_engine.discard(:card => game_engine.active_player_hand.first)
        end
      end

      it 'wraps all players in a current round player presenter' do
        expect(presenter.players.to_a).to all have_attributes(:class => CurrentRoundPlayerPresenter)
      end
    end
  end

  describe '#discard_pile_top_card' do
    it 'returns the top card of the discard pile' do
      expect(presenter.discard_pile_top_card).to eq game_engine.discard_pile.last
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

  describe '#round_over?' do
    it 'returns the round over flag from game state' do
      expect(presenter.round_over?).to eq game_engine.round_over?
    end
  end
end
