class CurrentRoundPlayerPresenter < SimpleDelegator
  attr_reader :cards

  def initialize(player:, cards:)
    super(player)
    @cards = cards
  end

  def to_model
    self
  end

  def to_partial_path
    'players/current_round_player'
  end
end
