module PlayableActions
  class StartRound < PlayableAction
    attr_reader :player_names

    def initialize(player_names:)
      @player_names = player_names
    end

    def apply_to(game_engine:)
      game_engine.start_round(:player_names => player_names)
    end
  end
end
