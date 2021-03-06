class AddToMeldsController < ApplicationController
  def create
    round = Round.with_game_and_players.find(params[:round_id])

    add_to_meld = AddToMelds.new(
      :round      => round,
      :card_names => selected_cards,
      :meld_rank  => selected_meld_rank)
    capture_errors(add_to_meld) unless add_to_meld.call

    redirect_to round
  end

  private

  def selected_cards
    params.require(:player_action).require(:selected_cards)
  end

  def selected_meld_rank
    params.require(:player_action).require(:selected_meld).to_sym
  end

  def capture_errors(service)
    flash[:errors] = service.errors
  end
end
