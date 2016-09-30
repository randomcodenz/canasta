require 'rails_helper'
require 'models/playable_behaviours'

describe Round, :type => :model do
  it { is_expected.to belong_to(:game) }

  it { is_expected.to have_many(:player_actions).dependent(:destroy) }

  it_behaves_like 'a playable object', Round.new

  describe '#deck_seed' do
    it { is_expected.to validate_presence_of(:deck_seed) }
  end
end
