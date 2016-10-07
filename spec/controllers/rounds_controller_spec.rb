require 'rails_helper'

describe RoundsController, :type => :controller do
  describe 'GET #show' do
    let(:game) do
      Game.create! do |game|
        game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
      end
    end
    let(:round_id) { round.id }
    let(:params) { { :id => round_id } }

    context 'when there is a current round' do
      let(:round) { game.rounds.create!(:deck_seed => 959) }

      before { get :show, params }

      it 'assigns the requested round to @round' do
        expect(assigns(:round)).to eq round
      end

      it 'wraps the requested round in a CurrentRoundPresenter' do
        expect(assigns(:round)).to be_an_instance_of CurrentRoundPresenter
      end
    end

    context 'when the round is over' do
      it 'redirects to the game'
    end
  end

  describe 'POST #create' do
    let(:game) { Game.create }
    let(:params) { { :game_id => game.id } }

    it 'creates a new round' do
      expect { post :create, params }.to change(Round, :count).by(1)
    end

    it 'redirects to the round' do
      post :create, params
      expect(response).to redirect_to game.rounds.last
    end
  end
end
