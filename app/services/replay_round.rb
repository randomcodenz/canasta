class ReplayRound
  attr_reader :round

  def initialize(round:)
    @round = round
  end

  def call
    event_stream = PlayableActionEnumerable.new(:round => round)
    GameEngine.new.tap do |game_engine|
      event_stream.each { |event| event.apply_to(:game_engine => game_engine) }
    end
  end
end
