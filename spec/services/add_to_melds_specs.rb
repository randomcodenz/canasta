require 'rails_helper'

describe AddToMelds do
  let(:game) do
    Game.create! do |game|
      game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
      game.rounds.new(:deck_seed => 959)
      game.rounds.last.player_actions << PlayerActions::PickUpCards.new
    end
  end
  let(:round) { game.rounds.last }
  let(:card_names_to_add_to_meld) { ['Ten of Spades', 'Ten of Diamonds'] }
  let(:cards_in_meld) do
    [
      Card.new(:rank => :ten, :suit => :hearts),
      Card.new(:rank => :ten, :suit => :diamonds),
    ]
  end

  subject(:service) { AddToMelds.new(:round => round, :card_names => card_names_to_add_to_meld) }

  context 'when adding to meld is a valid action' do
    before do
      meld = PlayerActions::Meld.new
      meld.meld_cards << cards_in_meld.map { |card| PlayerActionCard.from_card(:card => card) }
      round.player_actions << meld
    end

    it 'creates a new meld player action' do
      expect { service.call }.to change(PlayerAction, :count).by(1)

      service.call
      expect(round.player_actions.last.type).to eq PlayerActions::AddToMeld.name
      expect(round.player_actions.last.cards.map(&:to_card).map(&:to_s)).to eq card_names_to_add_to_meld
    end

    it 'returns true' do
      expect(service.call).to be true
    end
  end

  context 'when adding to meld is not a valid action' do
    it 'does not create any player actions' do
      game # MENTOR: lazy loading this in expect would cause PlayerAction.size to include PickUpCards
      expect { service.call }.not_to change(PlayerAction, :count)
    end

    it 'returns false' do
      expect(service.call).to be false
    end

    it 'provides errors indicating why discarding is not valid' do
      service.call
      expect(service.errors).not_to be_empty
    end
  end
end
