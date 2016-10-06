class PickUpCardsController < ApplicationController
  def create
    round = Round.with_game_and_players.find(params[:round_id])

    pick_up_cards = PickUpCards.new(:round => round)
    capture_errors(pick_up_cards) unless pick_up_cards.call

    redirect_to round
  end

  private

  def capture_errors(pick_up_cards)
    flash[:errors] = pick_up_cards.errors
  end
end
