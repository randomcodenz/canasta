class Meld
  attr_reader :cards

  def initialize(cards:)
    @cards = cards
  end

  def rank
    cards.find(&:natural?).rank
  end

  def wild?
    cards.any?(&:wild?)
  end

  def natural?
    cards.all?(&:natural?)
  end

  def bonus_points
    if natural?
      500
    elsif wild?
      300
    end
  end

  def points
    cards.map(&:points).reduce(:+) + bonus_points
  end
end
