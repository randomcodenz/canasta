require 'rails_helper'
require 'models/playable_behaviours'

describe Game, :type => :model do
  let(:player_names) { %w(P1 P2) }

  subject(:game) do
    Game.create! do |game|
      player_names.each { |name| game.players.new(:name => name) }
    end
  end

  it { is_expected.to have_many(:players).dependent(:destroy) }

  it { is_expected.to have_many(:rounds).dependent(:destroy) }

  describe '#current_round' do
    it 'returns the current round'
  end

  it_behaves_like 'a playable object' do
    let(:playable) { game }
  end

  describe 'playable implementation' do
    describe '#playable_action' do
      it 'returns a start round playable action' do
        expect(game.playable_action).to be_a(PlayableActions::StartRound)
      end

      it 'passes the player names to the start round playable action' do
        expect(game.playable_action.player_names).to contain_exactly(*player_names)
      end
    end
  end
end
