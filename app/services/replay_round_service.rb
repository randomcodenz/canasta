class ReplayRoundService
  attr_reader :round, :game_engine

  def initialize(round:)
    @round = round
  end

  def call
    @game_engine = GameEngine.new
    playable_actions.each do |playable_action|
      playable_action.apply_to(:game_context => game_engine)
    end
    game_engine
  end

  private

  def playable_actions
    round.game.playable_actions
  end
end
