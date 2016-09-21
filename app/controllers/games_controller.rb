class GamesController < ApplicationController
  # index, show, new, create, edit, update, destroy

  def index
  end

  def show
    @game = Game.includes(:players).find(params[:id])
  end

  def create
    @game = Game.new
    @game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
    @game.save!
    redirect_to @game
  end
end
