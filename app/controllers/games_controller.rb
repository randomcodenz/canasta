class GamesController < ApplicationController
  # index, show, new, create, edit, update, destroy

  def index
  end

  def show
    game = Game.includes(:players).find(params[:id])
    @game = GameSummaryPresenter.new(game)
  end

  def create
    create_game_service = CreateGameService.new
    game = create_game_service.call
    redirect_to game
  end
end
