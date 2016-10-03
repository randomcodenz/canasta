class PickUpCardsController < ApplicationController
  def create
    round = Round.with_game_and_players.find(params[:round_id])
    round.player_actions << PickUpCards.new
    redirect_to round
  end
end
