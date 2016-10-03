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

      it 'sets up the starting player' do
        game_engine.deal(:dealer => dealer)
        expect(game_engine.current_player_hand).to eq game_engine.player_hands[0]
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
        expect(game_engine.player_hands).to contain_exactly(*player_hands)
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

  describe '#can_pick_up_cards?' do
    context 'when the round has not been started' do
      it 'returns false' do
        expect(game_engine.can_pick_up_cards?).to be false
      end

      it 'sets an error indicating why the player cannot pick up' do
        game_engine.can_pick_up_cards?
        expect(game_engine.errors).to eq ['Round has not been started', 'Round has not been dealt']
      end
    end

    context 'when the round has not been dealt' do
      before do
        game_engine.start_round(:number_of_players => number_of_players)
      end

      it 'returns false' do
        expect(game_engine.can_pick_up_cards?).to be false
      end

      it 'sets an error indicating why the player cannot pick up' do
        game_engine.can_pick_up_cards?
        expect(game_engine.errors).to eq ['Round has not been dealt']
      end
    end

    context 'when the current player has not picked up from stock' do
      before do
        game_engine.start_round(:number_of_players => number_of_players)
        game_engine.deal(:dealer => dealer)
        # Deal again to add some errors
        game_engine.deal(:dealer => dealer)
      end

      it 'returns true' do
        expect(game_engine.can_pick_up_cards?).to be true
      end

      it 'clears any errors' do
        game_engine.can_pick_up_cards?
        expect(game_engine.errors).to be_empty
      end
    end

    context 'when the current player has picked up from stock' do
      before do
        game_engine.start_round(:number_of_players => number_of_players)
        game_engine.deal(:dealer => dealer)
        # Deal again to add some errors
        game_engine.deal(:dealer => dealer)
        game_engine.pick_up_cards
      end

      it 'returns false' do
        expect(game_engine.can_pick_up_cards?).to be false
      end

      it 'sets an error indicating why the player cannot pick up' do
        game_engine.can_pick_up_cards?
        expect(game_engine.errors).to eq ['Player has already picked up']
      end
    end

    context 'when the current player has picked up the discard pile' do
      it 'returns false'
      it 'sets an error indicating why the player cannot pick up'
    end
  end

  describe '#pick_up_cards' do
    before do
      game_engine.start_round(:number_of_players => number_of_players)
      game_engine.deal(:dealer => dealer)
      # Deal again to add some errors
      game_engine.deal(:dealer => dealer)
    end

    context 'when the current player has not picked up from stock' do
      let!(:stock_size) { game_engine.stock.size }
      let!(:current_player_hand_size) { game_engine.current_player_hand.size }
      let!(:top_two_cards) { game_engine.stock.take(2) }

      context 'when there are 2 players' do
        it 'takes the top 2 cards from stock' do
          game_engine.pick_up_cards
          expect(game_engine.stock.size).to eq stock_size - 2
        end

        it 'adds top 2 cards from stock to the current players hand' do
          game_engine.pick_up_cards
          expect(game_engine.current_player_hand.size).to eq current_player_hand_size + 2
          expect(game_engine.current_player_hand).to include(*top_two_cards)
        end

        it 'returns true' do
          expect(game_engine.pick_up_cards).to be true
        end

        it 'clears any errors' do
          game_engine.pick_up_cards
          expect(game_engine.errors).to be_empty
        end
      end
    end

    context 'when the current player has picked up from stock' do
      before { game_engine.pick_up_cards }

      it 'does not take any cards from stock' do
        expect { game_engine.pick_up_cards }.not_to change(game_engine.stock, :size)
      end

      it 'does not add any cards to the players hand' do
        expect { game_engine.pick_up_cards }.not_to change(game_engine.current_player_hand, :size)
      end

      it 'returns false' do
        expect(game_engine.pick_up_cards).to be false
      end

      it 'sets an error indicating why the player cannot pick up' do
        game_engine.pick_up_cards
        expect(game_engine.errors).to eq ['Player has already picked up']
      end
    end

    context 'when the current player has picked up the discard pile' do
      it 'does not take the discard pile'
      it 'does not add any cards to the players hand'
      it 'returns false'
      it 'sets an error indicating why the player cannot pick up'
    end
  end
end