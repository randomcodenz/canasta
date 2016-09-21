require 'rails_helper'

describe RoundsController, :type => :controller do
  describe 'POST #create' do
    let(:game) { Game.create }
    let(:params) { { :game_id => game.id } }

    it 'creates a new round' do
      expect { post :create, params }.to change(Round, :count).by(1)
    end

    it 'redirects to the game' do
      post :create, params
      expect(response).to redirect_to(game)
    end
  end
end
