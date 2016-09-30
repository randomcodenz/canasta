require 'rails_helper'
require 'models/playable_behaviours'

describe Game, :type => :model do
  it { is_expected.to have_many(:players).dependent(:destroy) }

  it { is_expected.to have_many(:rounds).dependent(:destroy) }

  it_behaves_like 'a playable object', Game.new
end
