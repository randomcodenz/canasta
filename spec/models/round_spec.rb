require 'rails_helper'

describe Round, :type => :model do
  it { is_expected.to belong_to(:game) }

  describe '#deck_seed' do
    it { is_expected.to validate_presence_of(:deck_seed) }
  end
end
