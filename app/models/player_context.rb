class PlayerContext
  attr_reader :index, :name, :melds
  attr_accessor :hand, :picked_up

  def initialize(index:, name:)
    @index = index
    @name = name
    @melds = []
    @picked_up = false
  end

  def points_in_hand
    hand.map(&:points).reduce(:+)
  end

  def round_score
    meld_points - points_in_hand
  end

  def meld_points
    melds.map(&:points).reduce(:+)
  end
end
