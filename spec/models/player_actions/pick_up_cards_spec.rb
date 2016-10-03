require 'rails_helper'
require 'models/playable_behaviours'

describe PickUpCards, :type => :model do
  subject(:pick_up_cards) { PickUpCards.new }

  it 'extends player action' do
    expect(pick_up_cards).to be_a(PlayerAction)
  end

  it_behaves_like 'a playable object' do
    let(:playable) { pick_up_cards }
  end
end
