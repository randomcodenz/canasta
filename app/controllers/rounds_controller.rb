class RoundsController < ApplicationController
  def show
    current_round = Round.with_game_and_players.find(params[:id])
    service = ReplayRoundService.new(:round => current_round)
    game_state = service.call

    @round = CurrentRoundPresenter.new(
      :current_round => current_round,
      :game_state => game_state
    )
  end

  def create
    service = CreateRoundService.new(:game_id => params[:game_id])
    round = service.call
    redirect_to round
  end
end
