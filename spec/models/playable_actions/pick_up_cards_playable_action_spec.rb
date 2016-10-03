require 'rails_helper'

describe PickUpCardsPlayableAction do
  let(:can_pick_up_cards) { true }
  let(:game_engine) do
    instance_double(
      GameEngine,
      :can_pick_up_cards? => can_pick_up_cards,
      :pick_up_cards => can_pick_up_cards
    )
  end

  subject(:playable_action) { PickUpCardsPlayableAction.new }

  describe '#apply_to' do
    before { playable_action.apply_to(:game_context => game_engine) }

    it 'asks game context to pick up cards' do
      expect(game_engine).to have_received(:pick_up_cards)
    end

    it 'returns the result of asking the game context to start a round' do
      expect(playable_action.apply_to(:game_context => game_engine)).to eq can_pick_up_cards
    end
  end
end
