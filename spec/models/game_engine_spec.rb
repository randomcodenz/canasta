require 'rails_helper'

shared_context 'validate operation' do |game_engine_method|
  let(:method) { game_engine_method }
  let(:method_args) { [] }
  let(:method_keyword_args) { {} }

  def call_game_engine_method
    if method_keyword_args.empty?
      game_engine.send(method, *method_args)
    else
      game_engine.send(method, *method_args, **method_keyword_args)
    end
  end
end

shared_context 'prepare to end round' do
  before do
    # Play the game until stock is empty and last player is ready to discard
    game_engine.start_round(:player_names => player_names)
    game_engine.deal(:dealer => dealer)
    game_engine.pick_up_cards
    until game_engine.stock.empty?
      game_engine.discard(:card => game_engine.active_player_hand.first)
      game_engine.pick_up_cards
    end
  end
end

shared_examples 'a valid operation' do |game_engine_method|
  include_context 'validate operation', game_engine_method

  it 'returns true' do
    expect(call_game_engine_method).to be true
  end

  it 'clears any errors' do
    call_game_engine_method
    expect(game_engine.errors).to be_empty
  end
end

shared_examples 'an invalid operation' do |game_engine_method|
  include_context 'validate operation', game_engine_method

  it 'returns false' do
    expect(call_game_engine_method).to be false
  end

  it 'sets one or more errors describing why the operation is invalid' do
    call_game_engine_method
    expect(game_engine.errors).to eq expected_errors
  end
end

describe GameEngine do
  let(:round_already_started) { 'Round has already been started' }
  let(:round_not_started) { 'Round has not been started' }
  let(:round_already_dealt) { 'Round has already been dealt' }
  let(:round_not_dealt) { 'Round has not been dealt' }
  let(:player_picked_up) { 'Player has already picked up' }
  let(:player_not_picked_up) { 'Player has not picked up' }
  let(:hand_missing_card) { "Hand does not include #{card_not_held}" }
  let(:player_missing_meld) { "Player does not have a meld of rank #{cards_to_add_to_meld.first.rank}" }
  let(:ranks_differ) { "Cards in meld must be of the same rank" }
  let(:meld_too_small) { "A meld must consist of three cards minimum" }
  let(:cards_with_different_ranks) { "Cards in meld must be of the same rank" }
  let(:too_many_wild_cards) { "A meld must contain three wild cards maximum" }
  let(:not_enough_natural_cards) { "A meld must contain more natural cards than wild" }
  let(:round_ended) { 'Round has ended' }
  let(:player_names) { ['Player 1', 'Player 2'] }
  let(:number_of_players) { player_names.size }
  let(:deck) { Deck.new(:seed => 959) }
  let(:dealer) { Dealer.new(:deck => deck) }
  let(:deal) { dealer.deal(:number_of_players => number_of_players) }
  let(:player_one_hand) { deal.player_hands[0] }

  subject(:game_engine) { GameEngine.new }

  describe '#can_start_round?' do
    context 'when a round has not been started' do
      it_behaves_like 'a valid operation', :can_start_round?
    end

    context 'when a round has been started' do
      before { game_engine.start_round(:player_names => player_names) }

      it_behaves_like 'an invalid operation', :can_start_round? do
        let(:expected_errors) { [round_already_started] }
      end
    end
  end

  describe '#start_round' do
    context 'when a round has not been started' do
      it 'captures the number of players' do
        game_engine.start_round(:player_names => player_names)
        expect(game_engine.number_of_players).to eq number_of_players
      end

      it_behaves_like 'a valid operation', :start_round do
        let(:method_keyword_args) { { :player_names => player_names } }
      end
    end

    context 'when a round has been started' do
      let(:new_player_names) { %w(1 2 3 4) }

      before { game_engine.start_round(:player_names => player_names) }

      it 'does not update the number of players' do
        game_engine.start_round(:player_names => new_player_names)
        expect(game_engine.number_of_players).to eq number_of_players
      end

      it_behaves_like 'an invalid operation', :start_round do
        let(:method_keyword_args) { { :player_names => new_player_names } }
        let(:expected_errors) { [round_already_started] }
      end
    end
  end

  describe '#can_deal?' do
    context 'when the round has not been started' do
      it_behaves_like 'an invalid operation', :can_deal? do
        let(:expected_errors) { [round_not_started] }
      end
    end

    context 'when the round has not been dealt' do
      before { game_engine.start_round(:player_names => player_names) }

      it_behaves_like 'a valid operation', :can_deal?
    end

    context 'when the round has already been dealt' do
      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
      end

      it_behaves_like 'an invalid operation', :can_deal? do
        let(:expected_errors) { [round_already_dealt] }
      end
    end
  end

  describe '#deal' do
    context 'when a round has not been dealt' do
      before { game_engine.start_round(:player_names => player_names) }

      it 'deals cards for the number of players in the game' do
        game_engine.deal(:dealer => dealer)
        expect(game_engine.player_hands.size).to eq number_of_players
      end

      it_behaves_like 'a valid operation', :deal do
        let(:method_keyword_args) { { :dealer => dealer } }
      end
    end

    context 'when a round has been dealt' do
      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
      end

      it 'does not deal the round again' do
        player_hands = game_engine.player_hands
        game_engine.deal(:dealer => dealer)
        expect(game_engine.player_hands).to contain_exactly(*player_hands)
      end

      it_behaves_like 'an invalid operation', :deal do
        let(:method_keyword_args) { { :dealer => dealer } }
        let(:expected_errors) { [round_already_dealt] }
      end
    end
  end

  describe '#can_pick_up_cards?' do
    context 'when the round has not been started' do
      it_behaves_like 'an invalid operation', :can_pick_up_cards? do
        let(:expected_errors) { [round_not_started, round_not_dealt] }
      end
    end

    context 'when the round has not been dealt' do
      before do
        game_engine.start_round(:player_names => player_names)
      end

      it_behaves_like 'an invalid operation', :can_pick_up_cards? do
        let(:expected_errors) { [round_not_dealt] }
      end
    end

    context 'when the current player has not picked up from stock' do
      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
        # Deal again to add some errors
        game_engine.deal(:dealer => dealer)
      end

      it_behaves_like 'a valid operation', :can_pick_up_cards?
    end

    context 'when the current player has picked up from stock' do
      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
        # Deal again to add some errors
        game_engine.deal(:dealer => dealer)
        game_engine.pick_up_cards
      end

      it_behaves_like 'an invalid operation', :can_pick_up_cards? do
        let(:expected_errors) { [player_picked_up] }
      end
    end

    context 'when the current player has picked up the discard pile' do
      it 'returns false'
      it 'sets an error indicating why the player cannot pick up'
    end

    context 'when the round is over' do
      include_context 'prepare to end round'

      before { game_engine.discard(:card => game_engine.active_player_hand.first) }

      it_behaves_like 'an invalid operation', :can_pick_up_cards? do
        let(:expected_errors) { [round_ended] }
      end
    end
  end

  describe '#pick_up_cards' do
    before do
      game_engine.start_round(:player_names => player_names)
      game_engine.deal(:dealer => dealer)
      # Deal again to add some errors
      game_engine.deal(:dealer => dealer)
    end

    context 'when the active player has not picked up from stock' do
      let!(:stock_size) { game_engine.stock.size }
      let!(:active_player_hand_size) { game_engine.active_player_hand.size }
      let!(:top_two_cards) { game_engine.stock.take(2) }

      context 'when there are 2 players' do
        it 'takes the top 2 cards from stock' do
          game_engine.pick_up_cards
          expect(game_engine.stock.size).to eq stock_size - 2
        end

        it 'adds top 2 cards from stock to the active players hand' do
          game_engine.pick_up_cards
          expect(game_engine.active_player_hand.size).to eq active_player_hand_size + 2
          expect(game_engine.active_player_hand).to include(*top_two_cards)
        end

        it 'tracks that the active player has picked up' do
          expect { game_engine.pick_up_cards }
            .to change { game_engine.active_player.picked_up }.from(false).to(true)
        end

        it_behaves_like 'a valid operation', :pick_up_cards
      end
    end

    context 'when the active player has picked up from stock' do
      before { game_engine.pick_up_cards }

      it 'does not take any cards from stock' do
        expect { game_engine.pick_up_cards }.not_to change(game_engine.stock, :size)
      end

      it 'does not add any cards to the players hand' do
        expect { game_engine.pick_up_cards }.not_to change(game_engine.active_player_hand, :size)
      end

      it_behaves_like 'an invalid operation', :pick_up_cards do
        let(:expected_errors) { [player_picked_up] }
      end
    end

    context 'when the active player has picked up the discard pile' do
      it 'does not take the discard pile'
      it 'does not add any cards to the players hand'
      it 'returns false'
      it 'sets an error indicating why the player cannot pick up'
    end

    context 'when the round is over' do
      include_context 'prepare to end round'

      before { game_engine.discard(:card => game_engine.active_player_hand.first) }

      it_behaves_like 'an invalid operation', :pick_up_cards do
        let(:expected_errors) { [round_ended] }
      end
    end
  end

  describe '#can_discard?' do
    context 'when the round has not been started' do
      it_behaves_like 'an invalid operation', :can_discard? do
        let(:expected_errors) { [round_not_started, round_not_dealt, player_not_picked_up] }
      end
    end

    context 'when the round has not been dealt' do
      before do
        game_engine.start_round(:player_names => player_names)
      end

      it_behaves_like 'an invalid operation', :can_discard? do
        let(:expected_errors) { [round_not_dealt, player_not_picked_up] }
      end
    end

    context 'when the current player has not picked up' do
      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
      end

      it_behaves_like 'an invalid operation', :can_discard? do
        let(:expected_errors) { [player_not_picked_up] }
      end
    end

    context 'when the current player has picked up' do
      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
        game_engine.pick_up_cards
      end

      it_behaves_like 'a valid operation', :can_discard?
    end

    context 'when the current players hand does not include the card' do
      let(:card_to_discard) { Card.new(:rank => :seven, :suit => :clubs) }
      let(:card_not_held) { card_to_discard }

      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
        game_engine.pick_up_cards
      end

      it_behaves_like 'an invalid operation', :can_discard? do
        let(:method_keyword_args) { { :card => card_to_discard } }
        let(:expected_errors) { [hand_missing_card] }
      end
    end
  end

  describe '#discard' do
    let(:card_to_discard) { player_one_hand[1] }

    context 'when the round has not been started' do
      it 'does not change the current player' do
        expect { game_engine.discard(:card => card_to_discard) }.not_to change(game_engine.active_player, :object_id)
      end

      it_behaves_like 'an invalid operation', :discard do
        let(:method_keyword_args) { { :card => card_to_discard } }
        let(:expected_errors) { [round_not_started, round_not_dealt, player_not_picked_up] }
      end
    end

    context 'when the round has not been dealt' do
      before do
        game_engine.start_round(:player_names => player_names)
      end

      it 'does not change the active player' do
        expect { game_engine.discard(:card => card_to_discard) }.not_to change(game_engine.active_player, :object_id)
      end

      it_behaves_like 'an invalid operation', :discard do
        let(:method_keyword_args) { { :card => card_to_discard } }
        let(:expected_errors) { [round_not_dealt, player_not_picked_up] }
      end
    end

    context 'when the active player has not picked up' do
      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
      end

      it 'does not remove any cards from the active players hand' do
        expect { game_engine.discard(:card => card_to_discard) }.not_to change(game_engine.active_player_hand, :size)
      end

      it 'does not add any cards to the discard pile' do
        expect { game_engine.discard(:card => card_to_discard) }.not_to change(game_engine.discard_pile, :size)
      end

      it 'does not change the active player' do
        expect { game_engine.discard(:card => card_to_discard) }.not_to change(game_engine.active_player, :object_id)
      end

      it_behaves_like 'an invalid operation', :discard do
        let(:method_keyword_args) { { :card => card_to_discard } }
        let(:expected_errors) { [player_not_picked_up] }
      end
    end

    context 'when the active player has picked up' do
      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
        game_engine.pick_up_cards
      end

      it 'removes the card from the active players hand' do
        active_player_hand = game_engine.active_player_hand
        card_to_discard_count = game_engine.active_player_hand.count { |card| card == card_to_discard }

        expect { game_engine.discard(:card => card_to_discard) }
          .to change { active_player_hand.count { |card| card == card_to_discard } }
          .from(card_to_discard_count).to(card_to_discard_count - 1)
      end

      it 'adds the card to the discard pile' do
        discarded_card_count = game_engine.discard_pile.count { |card| card == card_to_discard }
        expect { game_engine.discard(:card => card_to_discard) }
          .to change { game_engine.discard_pile.count { |card| card == card_to_discard } }
          .from(discarded_card_count).to(discarded_card_count + 1)
      end

      it 'ends the active players turn' do
        expect { game_engine.discard(:card => card_to_discard) }.to change { game_engine.active_player }
      end

      it 'clears the picked_up flag from the active player' do
        active_player = game_engine.active_player
        expect { game_engine.discard(:card => card_to_discard) }
          .to change { active_player.picked_up }.from(true).to(false)
      end

      it_behaves_like 'a valid operation', :discard do
        let(:method_keyword_args) { { :card => card_to_discard } }
      end
    end

    context 'when the active player discards and there are no cards left in stock' do
      include_context 'prepare to end round'

      let(:card_to_discard) { game_engine.active_player_hand.first }

      it 'changes round over to true' do
        expect { game_engine.discard(:card => card_to_discard) }
          .to change { game_engine.round_over? }.from(false).to(true)
      end
    end
  end

  describe '#can_meld?' do
    context 'when the round has not been started' do
      it_behaves_like 'an invalid operation', :can_meld? do
        let(:expected_errors) { [round_not_started, round_not_dealt, player_not_picked_up] }
      end
    end

    context 'when the round has not been dealt' do
      before do
        game_engine.start_round(:player_names => player_names)
      end

      it_behaves_like 'an invalid operation', :can_meld? do
        let(:expected_errors) { [round_not_dealt, player_not_picked_up] }
      end
    end

    context 'when the current player has not picked up' do
      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
      end

      it_behaves_like 'an invalid operation', :can_meld? do
        let(:expected_errors) { [player_not_picked_up] }
      end
    end

    context 'when the current player has picked up' do
      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
        game_engine.pick_up_cards
      end

      it_behaves_like 'a valid operation', :can_meld?

      context 'when the current players hand does not include any of the  cards' do
        let(:cards_to_meld) do
          [
            Card.new(:rank => :ten, :suit => :spades),
            Card.new(:rank => :ten, :suit => :hearts),
            Card.new(:rank => :ten, :suit => :clubs)
          ]
        end
        let(:card_not_held) { cards_to_meld[2] }

        it_behaves_like 'an invalid operation', :can_meld? do
          let(:method_keyword_args) { { :cards => cards_to_meld } }
          let(:expected_errors) { [hand_missing_card] }
        end
      end

      context 'when there are less than three cards to meld' do
        let(:cards_to_meld) do
          [
            Card.new(:rank => :ten, :suit => :spades),
            Card.new(:rank => :ten, :suit => :hearts),
          ]
        end

        it_behaves_like 'an invalid operation', :can_meld? do
          let(:method_keyword_args) { { :cards => cards_to_meld } }
          let(:expected_errors) do
            [meld_too_small]
          end
        end
      end

      context 'when the cards to meld are not of the same rank' do
        let(:cards_to_meld) do
          [
            Card.new(:rank => :ten, :suit => :spades),
            Card.new(:rank => :ten, :suit => :hearts),
            Card.new(:rank => :jack, :suit => :spades)
          ]
        end

        it_behaves_like 'an invalid operation', :can_meld? do
          let(:method_keyword_args) { { :cards => cards_to_meld } }
          let(:expected_errors) do
            [cards_with_different_ranks]
          end
        end
      end

      context 'when the cards to meld contain wild cards' do
        let(:cards_to_meld) do
          [
            Card.new(:rank => :ten, :suit => :spades),
            Card.new(:rank => :ten, :suit => :hearts),
            Card.new(:rank => :joker)
          ]
        end

        it_behaves_like 'a valid operation', :can_meld? do
          let(:method_keyword_args) { { :cards => cards_to_meld } }
        end
      end

      context 'when the cards to meld contain more than three wild cards' do
        let(:cards_to_meld) do
          [
            Card.new(:rank => :ten, :suit => :spades),
            Card.new(:rank => :ten, :suit => :hearts),
            Card.new(:rank => :joker),
            Card.new(:rank => :joker),
            Card.new(:rank => :joker),
            Card.new(:rank => :joker)
          ]
        end

        it_behaves_like 'an invalid operation', :can_meld? do
          let(:method_keyword_args) { { :cards => cards_to_meld } }
          let(:expected_errors) do
            [not_enough_natural_cards, too_many_wild_cards]
          end
        end
      end

      context 'when the cards to meld do not contain at least one more natural card than wild' do
        let(:cards_to_meld) do
          [
            Card.new(:rank => :ten, :suit => :spades),
            Card.new(:rank => :ten, :suit => :hearts),
            Card.new(:rank => :joker),
            Card.new(:rank => :joker),
            Card.new(:rank => :joker)
          ]
        end

        it_behaves_like 'an invalid operation', :can_meld? do
          let(:method_keyword_args) { { :cards => cards_to_meld } }
          let(:expected_errors) do
            [not_enough_natural_cards]
          end
        end
      end
    end
  end

  describe '#meld' do
    let(:cards_to_meld) do
      [
        Card.new(:rank => :ten, :suit => :spades),
        Card.new(:rank => :ten, :suit => :hearts),
        Card.new(:rank => :joker)
      ]
    end

    context 'when the round has not been started' do
      it_behaves_like 'an invalid operation', :can_meld? do
        let(:expected_errors) { [round_not_started, round_not_dealt, player_not_picked_up] }
      end
    end

    context 'when the round has not been dealt' do
      before do
        game_engine.start_round(:player_names => player_names)
      end

      it_behaves_like 'an invalid operation', :can_meld? do
        let(:expected_errors) { [round_not_dealt, player_not_picked_up] }
      end
    end

    context 'when the active player has not picked up' do
      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
      end

      it 'does not remove any cards from the active players hand' do
        expect { game_engine.meld(:cards => cards_to_meld) }.not_to change(game_engine.active_player_hand, :size)
      end

      it_behaves_like 'an invalid operation', :can_meld? do
        let(:expected_errors) { [player_not_picked_up] }
      end
    end

    context 'when the active player has picked up' do
      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
        game_engine.pick_up_cards
      end

      it 'removes the cards from the active players hand' do
        active_player_hand = game_engine.active_player_hand.dup
        game_engine.meld(:cards => cards_to_meld)
        melded_cards = active_player_hand - game_engine.active_player_hand
        expect(melded_cards.sort).to eq cards_to_meld.sort
      end

      it 'creates a new player meld' do
        game_engine.meld(:cards => cards_to_meld)
        expect(game_engine.active_player_melds.first.cards).to match cards_to_meld
      end

      it_behaves_like 'a valid operation', :meld do
        let(:method_keyword_args) { { :cards => cards_to_meld } }
      end
    end
  end

  describe '#can_add_to_meld?' do
    context 'when the round has not been started' do
      it_behaves_like 'an invalid operation', :can_add_to_meld? do
        let(:expected_errors) { [round_not_started, round_not_dealt, player_not_picked_up] }
      end
    end

    context 'when the round has not been dealt' do
      before do
        game_engine.start_round(:player_names => player_names)
      end

      it_behaves_like 'an invalid operation', :can_add_to_meld? do
        let(:expected_errors) { [round_not_dealt, player_not_picked_up] }
      end
    end

    context 'when the current player has not picked up' do
      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
      end

      it_behaves_like 'an invalid operation', :can_add_to_meld? do
        let(:expected_errors) { [player_not_picked_up] }
      end
    end

    context 'when the current player has picked up' do
      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
        game_engine.pick_up_cards
      end

      it_behaves_like 'a valid operation', :can_add_to_meld?

      context 'when the current players hand does not include the card' do
        let(:cards_to_add_to_meld) { [Card.new(:rank => :seven, :suit => :spades)] }
        let(:card_not_held) { cards_to_add_to_meld.first }
        let(:non_existent_meld_rank) { cards_to_add_to_meld.first.rank }

        it_behaves_like 'an invalid operation', :can_add_to_meld? do
          let(:method_keyword_args) { { :meld_rank => non_existent_meld_rank, :cards => cards_to_add_to_meld } }
          let(:expected_errors) { [hand_missing_card] }
        end
      end

      context 'when the current player has no matching rank' do
        let(:cards_to_add_to_meld) { [Card.new(:rank => :ten, :suit => :spades)] }
        let(:non_existent_meld_rank) { cards_to_add_to_meld.first.rank }

        it_behaves_like 'an invalid operation', :can_add_to_meld? do
          let(:method_keyword_args) { { :meld_rank => non_existent_meld_rank, :cards => cards_to_add_to_meld } }
          let(:expected_errors) { [player_missing_meld] }
        end
      end

      context 'when the player has matching meld' do
        let(:existing_meld_rank) { :ten }
        before do
          game_engine.active_player_melds << Meld.new(
            :cards => Array.new(3, Card.new(:rank => existing_meld_rank, :suit => :spades)))
        end

        context 'when the target meld rank and card rank do not match' do
          let(:cards_to_add_to_meld) { [Card.new(:rank => :jack, :suit => :spades)] }

          it_behaves_like 'an invalid operation', :can_add_to_meld? do
            let(:method_keyword_args) { { :meld_rank => existing_meld_rank, :cards => cards_to_add_to_meld } }
            let(:expected_errors) { [ranks_differ] }
          end
        end

        context 'when adding multiple valid cards' do
          let(:cards_to_add_to_meld) { Array.new(2, Card.new(:rank => existing_meld_rank, :suit => :hearts)) }

          it_behaves_like 'a valid operation', :can_add_to_meld? do
            let(:method_keyword_args) { { :meld_rank => existing_meld_rank, :cards => cards_to_add_to_meld } }
          end
        end

        context 'when adding a wild card' do
          let(:cards_to_add_to_meld) { [Card.new(:rank => :joker)] }

          it_behaves_like 'a valid operation', :can_add_to_meld? do
            let(:method_keyword_args) { { :meld_rank => existing_meld_rank, :cards => cards_to_add_to_meld } }
          end
        end

        context 'when the card is natural and ranks match' do
          let(:cards_to_add_to_meld) { [Card.new(:rank => existing_meld_rank, :suit => :spades)] }

          it_behaves_like 'a valid operation', :can_add_to_meld? do
            let(:method_keyword_args) { { :meld_rank => existing_meld_rank, :cards => cards_to_add_to_meld } }
          end
        end

        context 'when there are not more natural cards than wild' do
          let(:cards_to_add_to_meld) { Array.new(3, Card.new(:rank => :joker)) }

          it_behaves_like 'an invalid operation', :can_add_to_meld? do
            let(:method_keyword_args) { { :meld_rank => existing_meld_rank, :cards => cards_to_add_to_meld } }
            let(:expected_errors) { [not_enough_natural_cards] }
          end
        end

        context 'when the resulting meld has too many wild cards' do
          let(:cards_to_add_to_meld) { Array.new(4, Card.new(:rank => :joker)) }

          it_behaves_like 'an invalid operation', :can_add_to_meld? do
            let(:method_keyword_args) { { :meld_rank => existing_meld_rank, :cards => cards_to_add_to_meld } }
            let(:expected_errors) { [not_enough_natural_cards, too_many_wild_cards] }
          end
        end
      end
    end
  end

  describe '#add_to_meld' do

    context 'when the operation is invalid' do
      let(:cards_to_add_to_meld) { [Card.new(:rank => :ten, :suit => :hearts)] }
      let(:meld_rank) { cards_to_add_to_meld.first.rank }

      it_behaves_like 'an invalid operation', :add_to_meld do
        let(:method_keyword_args) { { :meld_rank => meld_rank, :cards => cards_to_add_to_meld } }
        let(:expected_errors) { [round_not_started, round_not_dealt, player_not_picked_up] }
      end
    end

    context 'when the operation is valid' do
      let(:existing_meld_rank) { :ten }
      let(:cards_to_add_to_meld) { [Card.new(:rank => existing_meld_rank, :suit => :hearts)] }

      before do
        game_engine.start_round(:player_names => player_names)
        game_engine.deal(:dealer => dealer)
        game_engine.pick_up_cards
        game_engine.active_player_melds << Meld.new(
          :cards => Array.new(2, Card.new(:rank => existing_meld_rank, :suit => :spades)))
      end

      it_behaves_like 'a valid operation', :add_to_meld do
        let(:method_keyword_args) { { :meld_rank => existing_meld_rank, :cards => cards_to_add_to_meld } }
      end

      it 'removes the cards from the active players hand' do
        expect { game_engine.add_to_meld(:meld_rank => existing_meld_rank, :cards => cards_to_add_to_meld) }
        .to change { game_engine.active_player_hand.count }.by(-cards_to_add_to_meld.size)
      end

      it 'adds the cards to the matching meld' do
        game_engine.add_to_meld(:meld_rank => existing_meld_rank, :cards => cards_to_add_to_meld)
        cards_to_add_to_meld.each { |card| expect(game_engine.active_player_melds.first.cards).to include card }
      end
    end
  end
end
