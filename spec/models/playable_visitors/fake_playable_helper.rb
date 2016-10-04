module FakePlayableHelper
  def self.playable_sequence(node_names)
    parent_node = nil
    node_names.reverse.each { |node_name| parent_node = FakePlayable.new(node_name, parent_node) }
    parent_node
  end

  class FakeGameEngine < Array
  end

  class FakePlayableAction
    def apply_to(game_engine:)
      game_engine << self
    end
  end

  class FakePlayable
    include Playable

    attr_accessor :parent_playable
    attr_reader :name, :child_playables, :playable_actions, :playable_action

    def initialize(name, child_playable = nil)
      @name = name
      @child_playables = [child_playable].compact
      child_playable.parent_playable = self if child_playable

      @playable_action = FakePlayableAction.new
      @playable_actions = [playable_action]
    end

    def root_playable?
      parent_playable.nil?
    end

    def inspect
      "FakePlayable #{name}: #{object_id}"
    end
  end
end
