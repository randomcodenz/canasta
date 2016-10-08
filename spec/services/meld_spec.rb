require 'rails_helper'

describe Meld do
  subject(:game) do
    Game.create! do |game|
      game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
      game.rounds.new(:deck_seed => 959)
    end
  end
  let(:round) { game.rounds.last }
  let(:card_names) { ['Joker', 'Ace of Spades', 'Ace of Diamonds'] }

  subject(:service) { Meld.new(:round => round, :card_names => card_names) }

  context 'when melding is a valid action' do
    before { round.player_actions << PlayerActions::PickUpCards.new }

    it 'creates a new meld player action' # do
    # expect { service.call }.to change(PlayerAction, :count).by(1)
    #
    #   service.call
    #   expect(round.player_actions.last.type).to eq PlayerActions::Discard.name
    #   expect(round.player_actions.last.card_name).to eq card_name
    # end

    it 'returns true' do
      expect(service.call).to be true
    end
  end

  context 'when melding is not a valid action' do
    it 'does not create any player actions' # do
    #   expect { service.call }.not_to change(PlayerAction, :count)
    # end

    it 'returns false' do
      expect(service.call).to be false
    end

    it 'provides errors indicating why discarding is not valid' do
      service.call
      expect(service.errors).not_to be_empty
    end
  end
end
