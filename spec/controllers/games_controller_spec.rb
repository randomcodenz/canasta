require 'rails_helper'

describe GamesController, :type => :controller do
  describe '#index' do
    before { get :index }

    it { is_expected.to render_template('index') }
  end

  describe '#show' do
    before do
      @game = Game.new
      @game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
      @game.save!
      get :show, :id => @game
    end

    it { is_expected.to render_template('show') }

    it 'assigns the requested game to @game' do
      expect(assigns(:game)).to eq Game.last
    end
  end

  describe '#create' do
    it 'creates a new game' do
      expect { post :create }.to change(Game, :count).by(1)
    end

    it 'creates 2 default players for the new game' do
      post :create
      expect(Game.last.players.collect(&:name))
        .to contain_exactly('Player 1', 'Player 2')
    end

    it 'redirects to the new game' do
      post :create
      expect(response).to redirect_to(Game.last)
    end
  end
end
