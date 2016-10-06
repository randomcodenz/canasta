require 'bigint_random_seed'

class CreateRound
  attr_reader :game_id, :seed_generator

  def initialize(game_id:, seed_generator: BigIntRandomSeed.itself)
    @game_id = game_id
    @seed_generator = seed_generator
  end

  def call
    game = Game.find(game_id)
    game.rounds.create!(:deck_seed => seed_generator.new_seed)
  end
end
