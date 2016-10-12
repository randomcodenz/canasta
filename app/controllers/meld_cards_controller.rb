class MeldCardsController < ApplicationController
  def create
    round = Round.with_game_and_players.find(params[:round_id])

    meld = MeldCards.new(:round => round, :card_names => selected_cards)
    capture_errors(meld) unless meld.call

    redirect_to round
  end

  private

  def selected_cards
    params.require(:player_action).require(:selected_cards)
  end

  def capture_errors(meld)
    flash[:errors] = meld.errors
  end
end
