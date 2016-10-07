require 'rails_helper'

module PlayableActions
  describe StartRound do
    let(:can_start_round) { true }
    let(:player_names) { %w(P1 P2) }
    let(:game_engine) do
      instance_double(
        GameEngine,
        :can_start_round? => can_start_round,
        :start_round => can_start_round
      )
    end

    subject(:playable_action) { StartRound.new(:player_names => player_names) }

    describe '#apply_to' do
      before { playable_action.apply_to(:game_engine => game_engine) }

      it 'asks game context to start a round specifiying the player names' do
        expect(game_engine).to have_received(:start_round).with(:player_names => player_names)
      end

      it 'returns the result of asking the game context to start a round' do
        expect(playable_action.apply_to(:game_engine => game_engine)).to eq can_start_round
      end
    end
  end
end
