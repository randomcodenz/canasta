require 'bigint_random_seed'

class RoundsController < ApplicationController
  def show
    @round = Round.with_game_and_players.find(params[:id])
    game = @round.game
    dealt_cards = deal(game, @round)
    @game = CurrentRoundGamePresenter.new(:game => game, :game_state => dealt_cards)
  end

  def create
    game = Game.find(params[:game_id])
    round = game.rounds.create!(:deck_seed => BigIntRandomSeed.new_seed)
    redirect_to round
  end

  private

  def deal(game, round)
    deck = Deck.new(:seed => round.deck_seed)
    dealer = Dealer.new(:deck => deck)
    dealer.deal(:number_of_players => game.players.count)
  end
end
