require 'rails_helper'
require 'models/playable_behaviours'

describe PickUpCards, :type => :model do
  subject(:pick_up_cards) { PickUpCards.new }

  it 'extends player action' do
    expect(pick_up_cards).to be_a(PlayerAction)
  end

  # TODO: Fix this - why can't we pass pick_up_cards here?
  it_behaves_like 'a playable object', PickUpCards.new
end
