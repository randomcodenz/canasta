class PlayerContext
  attr_reader :index, :name
  attr_accessor :hand, :picked_up

  def initialize(index:, name:)
    @index = index
    @name = name
  end
end
