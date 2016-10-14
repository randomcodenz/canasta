class AddToMeldsController < ApplicationController
  def create
    round = Round.with_game_and_players.find(params[:round_id])

    add_to_meld = AddToMelds.new(:round => round, :card_names => selected_cards)
    capture_errors(add_to_meld) unless add_to_meld.call

    redirect_to round
  end

  private

  def selected_cards
    params.require(:player_action).require(:selected_cards)
  end

  def capture_errors(service)
    flash[:errors] = service.errors
  end
end
