class Game < ActiveRecord::Base
  include Playable

  has_many :players, :dependent => :destroy
  has_many :rounds, :dependent => :destroy

  def playable_action
    PlayableActions::StartRound.new(:player_names => player_names)
  end

  def player_names
    players.sort_by(&:id).map(&:name)
  end
end
