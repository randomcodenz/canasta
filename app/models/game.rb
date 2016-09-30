class Game < ActiveRecord::Base
  include Playable

  has_many :players, :dependent => :destroy
  has_many :rounds, :dependent => :destroy

  def playable_action
    StartRoundPlayableAction.new(:number_of_players => players.count)
  end
end
