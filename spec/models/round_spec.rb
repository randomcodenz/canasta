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
    describe '#parent_playable' do
      it 'returns the game' do
        expect(round.parent_playable).to eq game
      end
    end

    describe '#child_playables' do
      context 'when the round has player actions' do
        before { round.player_actions << PickUpCards.new }

        it 'returns the player actions' do
          expect(round.child_playables).to contain_exactly(*round.player_actions)
        end
      end

      context 'when the round has no player actions' do
        it 'returns an empty array' do
          expect(round.child_playables).to be_empty
        end
      end
    end

    describe '#playable_action' do
      it 'returns a deal round playable action' do
        expect(round.playable_action).to be_a(PlayableActions::DealRoundPlayableAction)
      end

      it 'passes the deck seed to the deal round playable action' do
        expect(round.playable_action.deck_seed).to eq round.deck_seed
      end
    end
  end
end
