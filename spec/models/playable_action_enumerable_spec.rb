require 'rails_helper'

describe PlayableActionEnumerable do
  describe '#each' do
    let(:game) do
      Game.create! do |game|
        game.players.new([{ :name => 'P1' }, { :name => 'P2' }])
        game.rounds.new(:deck_seed => 99_235)
        game.rounds.new(:deck_seed => 61_789)
      end
    end
    let(:round) { game.rounds.first }

    subject(:playable_actions) { PlayableActionEnumerable.new(:round => round) }

    context 'when the round has no player actions' do
      it 'returns the start round playable action first' do
        first_playable = playable_actions.each.first
        expect(first_playable).to be_a PlayableActions::StartRound
      end

      it 'returns the deal round playable action second' do
        second_playable = playable_actions.each.drop(1).first
        expect(second_playable).to be_a PlayableActions::DealRound
        expect(second_playable.deck_seed).to eq 99_235
      end
    end

    context 'when the round has player actions' do
      let(:pick_up_cards) { PlayerActions::PickUpCards.new }
      let(:discard) { PlayerActions::Discard.new(:card_name => 'Joker') }

      before do
        round.player_actions << pick_up_cards
        round.player_actions << discard
      end

      it 'returns the start round playable action first' do
        first_playable = playable_actions.each.first
        expect(first_playable).to be_a PlayableActions::StartRound
      end

      it 'returns the deal round playable action second' do
        second_playable = playable_actions.each.drop(1).first
        expect(second_playable).to be_a PlayableActions::DealRound
        expect(second_playable.deck_seed).to eq 99_235
      end

      it 'returns the playable actions in player action order' do
        third_playable = playable_actions.each.drop(2).first
        fourth_playable = playable_actions.each.drop(3).first
        expect(third_playable).to be_a PlayableActions::PickUpCards
        expect(fourth_playable).to be_a PlayableActions::Discard
        expect(fourth_playable.card_name).to eq 'Joker'
      end

      it 'returns the deal round playable action second' do
        second_playable = playable_actions.each.drop(1).first
        expect(second_playable).to be_a PlayableActions::DealRound
        expect(second_playable.deck_seed).to eq 99_235
      end
    end

    context 'when there are multiple rounds' do
      let(:round) { game.rounds.drop(1).first }

      it 'returns the playable action associated with the specified round' do
        deal_round = playable_actions.each.drop(1).first
        expect(deal_round.deck_seed).to eq 61_789
      end
    end
  end
end
