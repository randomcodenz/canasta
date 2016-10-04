require 'rails_helper'
require 'models/playable_behaviours'

describe Discard, :type => :model do
  let(:card_to_discard) { Card.new(:rank => :jack, :suit => :clubs) }
  let(:card_name) { card_to_discard.to_s }
  let(:game) do
    Game.create! do |game|
      game.players.new(:name => 'Player 1')
      game.players.new(:name => 'Player 2')
      game.rounds.new(:deck_seed => 959) do |round|
        round.player_actions << PickUpCards.new
        round.player_actions << Discard.new(:card_name => card_name)
      end
    end
  end
  let(:round) { game.rounds.last }

  subject(:discard) { round.player_actions.last }

  it { is_expected.to validate_presence_of(:card_name) }

  it 'extends player action' do
    expect(discard).to be_a(PlayerAction)
  end

  it_behaves_like 'a playable object' do
    let(:playable) { discard }
  end

  describe 'playable implementation' do
    describe '#parent_playable' do
      it 'returns the round' do
        expect(discard.parent_playable).to eq round
      end
    end

    describe '#playable_action' do
      it 'returns a discard playable action' do
        expect(discard.playable_action).to be_a(DiscardPlayableAction)
      end

      it 'passes the card name to the discard playable action' do
        expect(discard.playable_action.card_name).to eq card_name
      end
    end
  end
end
