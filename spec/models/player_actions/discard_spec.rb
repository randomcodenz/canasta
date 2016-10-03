require 'rails_helper'
require 'models/playable_behaviours'

describe Discard, :type => :model do
  let(:card_to_discard) { Card.new(:rank => :jack, :suit => :clubs) }
  let(:card_name) { card_to_discard.to_s }

  subject(:discard) { Discard.new(:card_name => card_name) }

  it { is_expected.to validate_presence_of(:card_name) }

  it 'extends player action' do
    expect(discard).to be_a(PlayerAction)
  end

  it_behaves_like 'a playable object' do
    let(:playable) { discard }
  end

  it 'passes the card name to the discard playable action' do
    playable_action = discard.playable_actions[0]
    expect(playable_action.card_name).to eq card_name
  end
end
