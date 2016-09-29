require 'rails_helper'
require 'ostruct'

describe GameEngine do
  let(:number_of_players) { 2 }
  let(:deck) { Deck.new(:seed => 959) }
  let(:dealer) { Dealer.new(:deck => deck) }

  subject(:game_engine) { GameEngine.new }

  describe '#can_start_round?' do
    context 'when a round has not been started' do
      it 'returns true' do
        expect(game_engine.can_start_round?).to be true
      end

      it 'clears any errors' do
        game_engine.can_start_round?
        expect(game_engine.errors).to be_empty
      end
    end

    context 'when a round has been started' do
      before { game_engine.start_round(:number_of_players => number_of_players) }

      it 'returns false' do
        expect(game_engine.can_start_round?).to be false
      end

      it 'sets an error indicating a round has already been started' do
        game_engine.can_start_round?
        expect(game_engine.errors).to eq ['Round has already been started']
      end
    end
  end

  describe '#start_round' do
    context 'when a round has not been started' do
      it 'captures the number of players' do
        game_engine.start_round(:number_of_players => number_of_players)
        expect(game_engine.number_of_players).to eq number_of_players
      end

      it 'returns true' do
        expect(game_engine.start_round(:number_of_players => number_of_players)).to be true
      end

      it 'clears any errors' do
        game_engine.start_round(:number_of_players => number_of_players)
        expect(game_engine.errors).to be_empty
      end
    end

    context 'when a round has been started' do
      let(:number_of_players) { 2 }

      before { game_engine.start_round(:number_of_players => number_of_players) }

      it 'does not update the number of players' do
        game_engine.start_round(:number_of_players => 4)
        expect(game_engine.number_of_players).to eq number_of_players
      end

      it 'returns false' do
        expect(game_engine.start_round(:number_of_players => number_of_players)).to be false
      end

      it 'sets an error indicating a round has already been started' do
        game_engine.start_round(:number_of_players => number_of_players)
        expect(game_engine.errors).to eq ['Round has already been started']
      end
    end
  end

  describe '#can_deal?' do
    context 'when the round has not been started' do
      it 'returns false' do
        expect(game_engine.can_deal?).to be false
      end

      it 'sets an error indicating why it cannot deal' do
        game_engine.can_deal?
        expect(game_engine.errors).to eq ['Round has not been started']
      end
    end

    context 'when the round has not been dealt' do
      before { game_engine.start_round(:number_of_players => number_of_players) }

      it 'returns true' do
        expect(game_engine.can_deal?).to be true
      end

      it 'clears any errors' do
        game_engine.can_deal?
        expect(game_engine.errors).to be_empty
      end
    end

    context 'when the round has already been dealt' do
      before do
        game_engine.start_round(:number_of_players => number_of_players)
        game_engine.deal(:dealer => dealer)
      end

      it 'returns false' do
        expect(game_engine.can_deal?).to be false
      end

      it 'sets an error indicating why it cannot deal' do
        game_engine.can_deal?
        expect(game_engine.errors).to eq ['Round has already been dealt']
      end
    end
  end

  describe '#deal' do
    context 'when a round has not been dealt' do
      before { game_engine.start_round(:number_of_players => number_of_players) }

      it 'deals cards for the number of players in the game' do
        game_engine.deal(:dealer => dealer)
        expect(game_engine.player_hands.size).to eq number_of_players
      end

      it 'returns true' do
        expect(game_engine.deal(:dealer => dealer)).to be true
      end

      it 'clears any errors' do
        game_engine.deal(:dealer => dealer)
        expect(game_engine.errors).to be_empty
      end
    end

    context 'when a round has been dealt' do
      before do
        game_engine.start_round(:number_of_players => number_of_players)
        game_engine.deal(:dealer => dealer)
      end

      it 'does not deal the round again' do
        player_hands = game_engine.player_hands
        game_engine.deal(:dealer => dealer)
        expect(game_engine.player_hands).to be player_hands
      end

      it 'returns false' do
        expect(game_engine.deal(:dealer => dealer)).to be false
      end

      it 'sets an error indicating why it cannot deal' do
        game_engine.deal(:dealer => dealer)
        expect(game_engine.errors).to eq ['Round has already been dealt']
      end
    end
  end
end
