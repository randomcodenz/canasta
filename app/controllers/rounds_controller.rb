require 'bigint_random_seed'

class RoundsController < ApplicationController
  def show
    round = Round.with_game_and_players.find(params[:id])
    game = round.game
    dealt_cards = deal(game, round)
    @game = CurrentRoundGamePresenter.new(
      :game => game,
      :current_round => round,
      :game_state => dealt_cards
    )
  end

  def create
    service = CreateRoundService.new(:game_id => params[:game_id])
    round = service.call
    redirect_to round
  end

  private

  def deal(game, round)
    deck = Deck.new(:seed => round.deck_seed)
    dealer = Dealer.new(:deck => deck)
    dealer.deal(:number_of_players => game.players.count)
  end
end
