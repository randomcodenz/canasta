class CurrentRoundPresenter < SimpleDelegator
  attr_reader :current_round

  def initialize(current_round:, game_state:)
    super(current_round)
    @game_state = game_state
  end

  def current_round_number
    game.rounds.count
  end

  def discard_pile_top_card
    game_state.discard_pile.last
  end

  def discard_pile_size
    game_state.discard_pile.size
  end

  def stock_size
    game_state.stock.size
  end

  def players
    game_state.players
      .sort_by(&:index)
      .map do |player|
        player_presenter(player)
      end
  end

  private

  attr_reader :game_state

  def player_presenter(player)
    if active_player?(player)
      CurrentRoundActivePlayerPresenter.new(:player => player, :round => self)
    else
      CurrentRoundPlayerPresenter.new(:player => player)
    end
  end

  def active_player?(player)
    player == game_state.active_player
  end
end
