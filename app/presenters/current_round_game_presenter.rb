class CurrentRoundGamePresenter < SimpleDelegator
  def initialize(game:, game_state:)
    super(game)
    @game_state = game_state
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

  def players
    super.sort_by(&:id)
      .zip(game_state.player_hands)
      .map { |player, cards| CurrentRoundPlayerPresenter.new(:player => player, :cards => cards) }
  end

  private

  attr_reader :game_state
end
