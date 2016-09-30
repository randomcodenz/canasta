require 'rails_helper'

describe PlayerAction, :type => :model do
  it { is_expected.to belong_to(:round) }
end
