module Playable
  def parent_playable
    # NullObject?
  end

  def root_playable?
    false
  end

  def child_playables
    []
  end

  # Override if the current instance maps to multiple playable actions
  def playable_actions
    [playable_action]
  end

  # Override if the current instance maps to a single playable action
  def playable_action
    raise NotImplementedError
  end

  def accept(playable_visitor:)
    playable_visitor.visit(self)
  end
end
