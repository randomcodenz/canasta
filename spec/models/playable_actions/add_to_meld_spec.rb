require 'rails_helper'

module PlayableActions
  describe AddToMeld do
    let(:can_add_to_meld) { true }
    let(:card_to_add_to_meld) { Card.new(:rank => :ace, :suit => :diamonds) }
    let(:game_engine) do
      instance_double(
        GameEngine,
        :can_add_to_meld? => can_add_to_meld,
        :add_to_meld => can_add_to_meld
      )
    end

    subject(:playable_action) { PlayableActions::AddToMeld.new(:card => card_to_add_to_meld) }

    describe '#apply_to' do
      before { playable_action.apply_to(:game_engine => game_engine) }

      it 'asks game context to add the specified card to a meld' do
        expect(game_engine).to have_received(:add_to_meld).with(:card => card_to_add_to_meld)
      end

      it 'returns the result of asking the game engine to add the card to the meld' do
        expect(playable_action.apply_to(:game_engine => game_engine)).to eq can_add_to_meld
      end
    end
  end
end
