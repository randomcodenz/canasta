require 'rails_helper'
require 'models/playable_behaviours'

module PlayerActions
  describe PickUpCards, :type => :model do
    let(:game) do
      Game.create! do |game|
        game.players.new(:name => 'Player 1')
        game.players.new(:name => 'Player 2')
        game.rounds.new(:deck_seed => 959) do |round|
          round.player_actions << PickUpCards.new
        end
      end
    end
    let(:round) { game.rounds.last }

    subject(:pick_up_cards) { round.player_actions.last }

    it 'extends player action' do
      expect(pick_up_cards).to be_a(PlayerAction)
    end

    it_behaves_like 'a playable object' do
      let(:playable) { pick_up_cards }
    end

    describe 'playable implementation' do
      describe '#parent_playable' do
        it 'returns the round' do
          expect(pick_up_cards.parent_playable).to eq round
        end
      end

      describe '#playable_action' do
        it 'returns a pick up cards playable action' do
          expect(pick_up_cards.playable_action).to be_a(PlayableActions::PickUpCardsPlayableAction)
        end
      end
    end
  end
end
