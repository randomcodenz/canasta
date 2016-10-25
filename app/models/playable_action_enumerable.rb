class PlayableActionEnumerable
  attr_reader :round

  def initialize(round:)
    @round = round
  end

  def each
    return enum_for(:each) unless block_given?

    yield round.game.playable_action
    yield round.playable_action
    round.player_actions.each do |player_action|
      player_action.playable_actions.each { |action| yield action }
    end
  end
end
