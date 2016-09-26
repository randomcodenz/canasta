class PlayerPresenter < SimpleDelegator
  attr_reader :cards

  def initialize(player:, cards: [])
    super(player)
    @cards = cards
  end
end
