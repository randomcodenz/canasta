class CurrentRoundGamePresenter < SimpleDelegator
  attr_reader :current_round, :game_state

  def initialize(current_round:, game_state:)
    super(current_round.game)
    @game_state = game_state
    @current_round = current_round
  end

  def current_round_number
    rounds.count
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
    super.sort_by(&:id)
      .zip(game_state.player_hands)
      .map { |player, cards| CurrentRoundPlayerPresenter.new(:player => player, :cards => cards) }
  end

  private

  attr_reader :game_state
end
