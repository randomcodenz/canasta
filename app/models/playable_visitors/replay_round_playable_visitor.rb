class ReplayRoundPlayableVisitor
  attr_reader :game_engine, :root_playable

  def initialize(game_engine:)
    @game_engine = game_engine
  end

  def visit(playable)
    @root_playable = find_root(playable)
    replay_actions(root_playable)
  end

  private

  def find_root(playable)
    find_root_visitor = PlayableVisitors::FindRootPlayableVisitor.new
    find_root_visitor.visit(playable)
  end

  def replay_actions(root_playable)
    apply_actions_visitor = PlayableVisitors::ApplyActionsPlayableVisitor.new(:game_engine => game_engine)
    apply_actions_visitor.visit(root_playable)
  end
end
