class CurrentRoundPlayerPresenter < SimpleDelegator
  def initialize(player:)
    super(player)
  end

  def hand
    super.sort
  end

  def hand_size
    hand.size
  end

  def to_model
    self
  end

  def to_partial_path
    'players/current_round_player'
  end
end
