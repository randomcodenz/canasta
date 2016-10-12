module Playable
  # Override if the current instance maps to multiple playable actions
  def playable_actions
    [playable_action]
  end

  # Override if the current instance maps to a single playable action
  def playable_action
    raise NotImplementedError
  end
end
