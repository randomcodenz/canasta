require 'rails_helper'

module PlayableActions
  describe PickUpCards do
    let(:can_pick_up_cards) { true }
    let(:game_engine) do
      instance_double(
        GameEngine,
        :can_pick_up_cards? => can_pick_up_cards,
        :pick_up_cards => can_pick_up_cards
      )
    end

    subject(:playable_action) { PickUpCards.new }

    describe '#apply_to' do
      before { playable_action.apply_to(:game_engine => game_engine) }

      it 'asks game context to pick up cards' do
        expect(game_engine).to have_received(:pick_up_cards)
      end

      it 'returns the result of asking the game engine to pick up cards' do
        expect(playable_action.apply_to(:game_engine => game_engine)).to eq can_pick_up_cards
      end
    end
  end
end
