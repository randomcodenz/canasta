class ReplayRoundService
  attr_reader :round, :game_engine

  def initialize(round:)
    @round = round
  end

  def call
    @game_engine = GameEngine.new
    replay_round = PlayableVisitors::ReplayRound.new(:game_engine => game_engine)
    round.accept(:playable_visitor => replay_round)
    game_engine
  end
end
