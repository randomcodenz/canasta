require 'rails_helper'

describe Game, :type => :model do
  it { is_expected.to have_many(:players).dependent(:destroy) }

  it { is_expected.to have_many(:rounds).dependent(:destroy) }
end
