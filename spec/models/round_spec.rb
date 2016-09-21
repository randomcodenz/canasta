require 'rails_helper'

describe Round, :type => :model do
  it { is_expected.to belong_to(:game) }
end
