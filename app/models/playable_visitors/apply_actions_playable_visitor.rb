class ApplyActionsPlayableVisitor
  attr_reader :game_engine

  def initialize(game_engine:)
    @game_engine = game_engine
  end

  def visit(playable)
    apply_actions(playable)
    apply_child_actions(playable)
  end

  private

  def apply_actions(playable)
    playable.playable_actions.each do |playable_action|
      playable_action.apply_to(:game_engine => game_engine)
    end
  end

  def apply_child_actions(playable)
    playable.child_playables.each do |child_playable|
      child_playable.accept(:playable_visitor => self)
    end
  end
end
