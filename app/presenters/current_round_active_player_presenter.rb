class CurrentRoundActivePlayerPresenter < SimpleDelegator
  attr_reader :round

  def initialize(player:, round:)
    super(player)
    @round = round
  end

  def hand
    # byebug
    super.sort
  end

  def hand_size
    hand.size
  end

  def to_model
    self
  end

  def to_partial_path
    'players/current_round_active_player'
  end
end
