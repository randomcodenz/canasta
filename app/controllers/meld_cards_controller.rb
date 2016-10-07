class MeldCardsController < ApplicationController
  def create
    round = Round.with_game_and_players.find(params[:round_id])
    redirect_to round
  end
end
