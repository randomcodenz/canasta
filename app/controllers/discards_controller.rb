class DiscardsController < ApplicationController
  def create
    round = Round.with_game_and_players.find(params[:round_id])
    round.player_actions << PlayerActions::Discard.new(:card_name => 'Jack of Clubs')
    redirect_to round
  end
end
