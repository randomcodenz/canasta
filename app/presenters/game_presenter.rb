class GamePresenter < SimpleDelegator
  def initialize(game:, game_state:)
    super(game)
    @game_state = game_state
  end

  def round_in_progress?
    rounds.any?
  end

  def current_round_number
    rounds.count || 0
  end

  def round_over?
    rounds.empty?
  end

  def players
    super.sort_by(&:id)
      .zip(player_hands)
      .map { |player, cards| PlayerPresenter.new(:player => player, :cards => cards || []) }
  end

  private

  attr_reader :game_state

  def player_hands
    game_state ? game_state.player_hands : []
  end
end
