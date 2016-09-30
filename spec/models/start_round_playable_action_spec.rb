require 'rails_helper'

describe StartRoundPlayableAction do
  let(:can_start_round) { true }
  let(:number_of_players) { 2 }
  let(:game_engine) { instance_double(GameEngine, :can_start_round? => can_start_round, :start_round => can_start_round) }

  subject(:playable_action) { StartRoundPlayableAction.new(:number_of_players => number_of_players) }

  describe '#apply_to' do
    before { playable_action.apply_to(game_engine) }

    it 'asks game context to start a round specifiying the number of players' do
      expect(game_engine).to have_received(:start_round).with(:number_of_players => number_of_players)
    end

    it 'returns the result of asking the game context to start a round' do
      expect(playable_action.apply_to(game_engine)).to eq can_start_round
    end
  end
end
