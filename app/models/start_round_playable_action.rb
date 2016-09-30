class StartRoundPlayableAction < PlayableAction
  attr_reader :number_of_players

  def initialize(number_of_players:)
    @number_of_players = number_of_players
  end

  def apply_to(game_context)
    game_context.start_round(:number_of_players => number_of_players)
  end
end
