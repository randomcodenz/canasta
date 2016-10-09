class PlayerContext
  attr_reader :index, :name, :melds
  attr_accessor :hand, :picked_up

  def initialize(index:, name:)
    @index = index
    @name = name
    @melds = []
    @picked_up = false
  end
end
