class GamesController < ApplicationController
  def index
  end

  def show
    game = Game.includes(:players).find(params[:id])
    @game = GameSummaryPresenter.new(game)
  end

  def create
    create_game = CreateGame.new
    game = create_game.call
    redirect_to game
  end
end
