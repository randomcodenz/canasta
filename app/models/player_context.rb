class PlayerContext
  attr_accessor :index, :hand, :picked_up

  def initialize(index:)
    @index = index
  end
end
