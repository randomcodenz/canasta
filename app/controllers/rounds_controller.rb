require 'bigint_random_seed'

class RoundsController < ApplicationController
  def show
    game = Game.includes(:players).find(params[:game_id])
    current_round = game.rounds.find(params[:id])
    dealt_cards = deal(game, current_round)
    @game = CurrentRoundGamePresenter.new(:game => game, :game_state => dealt_cards)
  end

  def create
    game = Game.find(params[:game_id])
    round = game.rounds.create!(:deck_seed => BigIntRandomSeed.new_seed)
    redirect_to game_round_path(game, round)
  end

  private

  def deal(game, current_round)
    if current_round
      deck = Deck.new(:seed => current_round.deck_seed)
      dealer = Dealer.new(:deck => deck, :number_of_players => game.players.count)
      dealer.deal
    end
  end
end
