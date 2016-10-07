require 'rails_helper'
require 'ostruct'

describe CreateRound do
  let(:game) { Game.create! }
  let(:deck_seed) { 969 }
  let(:seed_generator) { OpenStruct.new(:new_seed => deck_seed) }

  subject(:service) { CreateRound.new(:game_id => game.id, :seed_generator => seed_generator) }

  it 'creates a new round' do
    expect { service.call }.to change(game.rounds, :count).by(1)
  end

  it 'creates the round with a random deck seed' do
    service.call
    expect(game.rounds.last.deck_seed).to eq deck_seed
  end

  it 'returns the new round' do
    expect(service.call).to eq game.rounds.last
  end
end
