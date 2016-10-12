require 'rails_helper'

module PlayableActions
  describe Meld do
    let(:can_meld) { true }
    let(:cards_to_meld) do
      [
        Card.new(:rank => :ace, :suit => :diamonds),
        Card.new(:rank => :ace, :suit => :hearts),
        Card.new(:rank => :joker)
      ]
    end
    let(:game_engine) do
      instance_double(
        GameEngine,
        :can_meld? => can_meld,
        :meld => can_meld
      )
    end

    subject(:playable_action) { PlayableActions::Meld.new(:meld_cards => cards_to_meld) }

    describe '#apply_to' do
      before { playable_action.apply_to(:game_engine => game_engine) }

      it 'asks game context to meld the specified cards' do
        expect(game_engine).to have_received(:meld).with(:cards => cards_to_meld)
      end

      it 'returns the result of asking the game engine to meld' do
        expect(playable_action.apply_to(:game_engine => game_engine)).to eq can_meld
      end
    end
  end
end
