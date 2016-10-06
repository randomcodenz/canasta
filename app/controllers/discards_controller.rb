class DiscardsController < ApplicationController
  def create
    round = Round.with_game_and_players.find(params[:round_id])

    discard = Discard.new(:round => round, :card_name => card_name)
    capture_errors(discard) unless discard.call

    redirect_to round
  end

  private

  def card_name
    selected_cards.first
  end

  def selected_cards
    params.require(:player_action).require(:selected_cards)
  end

  def capture_errors(discard)
    flash[:errors] = discard.errors
  end
end
