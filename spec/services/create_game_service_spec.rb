require 'rails_helper'

describe CreateGameService do
  subject(:service) { CreateGameService.new }

  it 'creates a new game' do
    expect { service.call }.to change(Game, :count).by(1)
  end

  it 'creates 2 default players for the new game' do
    service.call
    expect(Game.last.players.collect(&:name)).to contain_exactly('Player 1', 'Player 2')
  end

  it 'returns the new game' do
    expect(service.call).to eq Game.last
  end
end
