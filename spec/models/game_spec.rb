require 'rails_helper'
require 'models/playable_behaviours'

describe Game, :type => :model do
  it { is_expected.to have_many(:players).dependent(:destroy) }

  it { is_expected.to have_many(:rounds).dependent(:destroy) }

  it_behaves_like 'a playable object' do
    let(:playable) { Game.new }
  end

  describe '#playable_actions' do
    # When a game has no rounds
    # When a game has 1 round
    # When a game has many rounds
    it 'the game action is the first action'
    it 'all actions from the current round are appended to the game action'
  end
end
