require 'rails_helper'

describe GamesController, :type => :controller do
  describe 'GET #index' do
    before { get :index }

    it { is_expected.to render_template('index') }
  end

  describe 'GET #show' do
    let(:game) do
      Game.create! do |game|
        game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
      end
    end

    before { get :show, :id => game }

    it { is_expected.to render_template('show') }

    it 'assigns the requested game to @game' do
      expect(assigns(:game)).to eq game
    end

    it 'wraps the requested game in a game summary presenter' do
      expect(assigns(:game)).to be_an_instance_of GameSummaryPresenter
    end
  end

  describe 'POST #create' do
    # TODO: How do we change this so we can mock the service and just assert
    # TODO: outcomes?
    it 'creates a new game' do
      expect { post :create }.to change(Game, :count).by(1)
    end

    it 'creates 2 default players for the new game' do
      post :create
      expect(Game.last.players.collect(&:name)).to contain_exactly('Player 1', 'Player 2')
    end

    it 'redirects to the new game' do
      post :create
      expect(response).to redirect_to(Game.last)
    end
  end
end
