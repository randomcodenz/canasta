require 'rails_helper'
require 'models/playable_behaviours'

module PlayerActions
  describe AddToMeld, :type => :model do
    let(:cards_to_meld) do
      [
        Card.new(:rank => :ace, :suit => :diamonds),
        Card.new(:rank => :ace, :suit => :hearts),
        Card.new(:rank => :joker)
      ]
    end
    let(:target_meld_rank) { cards_to_meld[0].rank }
    let(:meld_cards) { cards_to_meld.map { |card_to_meld| PlayerActionCard.from_card(:card => card_to_meld) } }
    let(:cards_to_add_to_meld) do
      [
        Card.new(:rank => :ace, :suit => :spades),
        Card.new(:rank => :ace, :suit => :hearts)
      ]
    end
    let(:added_cards) { cards_to_add_to_meld.map { |card_to_add_to_meld| PlayerActionCard.from_card(:card => card_to_add_to_meld) } }
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

          add_to_meld = AddToMeld.new do |new_add_to_meld|
            new_add_to_meld.cards << added_cards
            new_add_to_meld.target_meld_rank = target_meld_rank
          end
          round.player_actions << add_to_meld
        end
      end
    end
    let(:round) { game.rounds.last }

    subject(:add_to_meld) { round.player_actions.last }

    it do
      is_expected.to have_many(:cards)
        .class_name(PlayerActionCard.name)
        .with_foreign_key('player_action_id')
    end

    it 'extends player action' do
      expect(add_to_meld).to be_a(PlayerAction)
    end

    it_behaves_like 'a playable object' do
      let(:playable) { add_to_meld }
    end

    describe 'playable implementation' do
      describe '#playable_action' do
        it 'returns an add to meld playable action' do
          expect(add_to_meld.playable_action).to be_a(PlayableActions::AddToMeld)
        end
      end
    end
  end
end
