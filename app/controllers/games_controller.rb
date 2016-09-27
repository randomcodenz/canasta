class GamesController < ApplicationController
  # index, show, new, create, edit, update, destroy

  def index
  end

  def show
    game = Game.includes(:players).find(params[:id])
    @game = GameSummaryPresenter.new(game)
  end

  def create
    game = Game.create! do |new_game|
      new_game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
    end
    redirect_to game
  end
end
