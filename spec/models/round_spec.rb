require 'rails_helper'
require 'models/playable_behaviours'

describe Round, :type => :model do
  subject(:game) do
    Game.create! do |game|
      game.players.new(:name => 'Player 1')
      game.players.new(:name => 'Player 2')
      game.rounds.new(:deck_seed => 959)
    end
  end

  subject(:round) { game.rounds.last }

  it { is_expected.to belong_to(:game) }

  it { is_expected.to have_many(:player_actions).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:deck_seed) }

  it_behaves_like 'a playable object' do
    let(:playable) { round }
  end

  describe 'playable implementation' do
    describe '#playable_action' do
      it 'returns a deal round playable action' do
        expect(round.playable_action).to be_a(PlayableActions::DealRound)
      end

      it 'passes the deck seed to the deal round playable action' do
        expect(round.playable_action.deck_seed).to eq round.deck_seed
      end
    end
  end
end
