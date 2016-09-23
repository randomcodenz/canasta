require 'bigint_random_seed'

class RoundsController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    @game.rounds.create!(:deck_seed => BigIntRandomSeed.new_seed)
    redirect_to @game
    # Will need some way of creating and storing the deck + the deal
    # (player hands, stock and discard)
    # Round as a holder for event stream + seed for deck + snapshot (score)
    # at end of round may be the simplest way - flag a round as current so
    # we can only fetch the current round when rendering?
  end
end
