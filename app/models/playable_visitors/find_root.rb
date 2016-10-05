module PlayableVisitors
  class FindRoot
    def visit(playable)
      root_playable?(playable) ? playable : visit(playable.parent_playable)
    end

    private

    def root_playable?(playable)
      playable.root_playable? || playable.parent_playable.nil?
    end
  end
end
