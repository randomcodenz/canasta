require 'rails_helper'

module PlayableActions
  describe Discard do
    let(:can_discard) { true }
    let(:card_to_discard) { Card.new(:rank => :seven, :suit => :spades) }
    let(:card_name) { card_to_discard.to_s }
    let(:game_engine) do
      instance_double(
        GameEngine,
        :can_discard? => can_discard,
        :discard => can_discard
      )
    end

    subject(:playable_action) { Discard.new(:card_name => card_name) }

    it 'converts the card name to a card' do
      expect(playable_action.card).to eq card_to_discard
    end

    describe '#apply_to' do
      before { playable_action.apply_to(:game_context => game_engine) }

      it 'asks game context to discard the specified card' do
        expect(game_engine).to have_received(:discard).with(:card => card_to_discard)
      end

      it 'returns the result of asking the game context to discard' do
        expect(playable_action.apply_to(:game_context => game_engine)).to eq can_discard
      end
    end
  end
end
