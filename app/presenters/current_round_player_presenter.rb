class CurrentRoundPlayerPresenter < SimpleDelegator
  attr_reader :hand

  def initialize(player:, hand:)
    super(player)
    @hand = hand
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
