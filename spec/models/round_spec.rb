require 'rails_helper'
require 'models/playable_behaviours'

describe Round, :type => :model do
  it { is_expected.to belong_to(:game) }

  it { is_expected.to have_many(:player_actions).dependent(:destroy) }

  it_behaves_like 'a playable object', Round.new

  describe '#deck_seed' do
    it { is_expected.to validate_presence_of(:deck_seed) }
  end

  describe '#playable_actions' do
    # When a round has no player actions
    # When a round has player actions
    it 'returns the round action and all child player actions'
  end
end
