class PlayableAction
  def apply_to(game_context)
    raise NotImplementedError
  end
end
