require 'rails_helper'
require 'models/playable_behaviours'

module PlayerActions
  describe Meld, :type => :model do
    let(:cards_to_meld) do
      [
        Card.new(:rank => :ace, :suit => :diamonds),
        Card.new(:rank => :ace, :suit => :hearts),
        Card.new(:rank => :joker)
      ]
    end
    let(:meld_cards) { cards_to_meld.map { |card_to_meld| PlayerActionCard.from_card(:card => card_to_meld) } }
    let(:game) do
      Game.create! do |game|
        game.players.new(:name => 'Player 1')
        game.players.new(:name => 'Player 2')
        game.rounds.new(:deck_seed => 959) do |round|
          round.player_actions << PickUpCards.new
          meld = Meld.new do |new_meld|
            new_meld.meld_cards << meld_cards
          end
          round.player_actions << meld
        end
      end
    end
    let(:round) { game.rounds.last }

    subject(:meld) { round.player_actions.last }

    it do
      is_expected.to have_many(:meld_cards)
        .class_name(PlayerActionCard.name)
        .with_foreign_key('player_action_id')
    end

    it 'extends player action' do
      expect(meld).to be_a(PlayerAction)
    end

    it_behaves_like 'a playable object' do
      let(:playable) { meld }
    end

    describe 'playable implementation' do
      describe '#parent_playable' do
        it 'returns the round' do
          expect(meld.parent_playable).to eq round
        end
      end

      describe '#playable_action' do
        it 'returns a meld playable action' do
          expect(meld.playable_action).to be_a(PlayableActions::Meld)
        end

        it 'passes the meld cards to the meld playable action' do
          expect(meld.playable_action.meld_cards).to eq cards_to_meld
        end
      end
    end
  end
end
