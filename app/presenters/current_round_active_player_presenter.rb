class CurrentRoundActivePlayerPresenter < SimpleDelegator
  def initialize(player:)
    super(player)
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
