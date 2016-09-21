class GamesController < ApplicationController
  # index, show, new, create, edit, update, destroy

  def index
  end

  def show
  end

  def create
    @game = Game.create!
    redirect_to @game
  end
end
