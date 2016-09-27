require 'rails_helper'

describe Player, :type => :model do
  it { is_expected.to belong_to(:game) }

  context 'when validating a player' do
    let(:game) { Game.new }

    subject { game.players.new(:name => 'player 1') }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_length_of(:name).is_at_most(50) }

    it do
      is_expected.to validate_uniqueness_of(:name)
        .case_insensitive
        .scoped_to(:game_id)
    end
  end
end
