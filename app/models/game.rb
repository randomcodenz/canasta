class Game < ActiveRecord::Base
  include Playable

  has_many :players, :dependent => :destroy
  has_many :rounds, :dependent => :destroy

  def current_round
    # TODO : Naive implementation - needs review
    rounds.last
  end

  def root_playable?
    true
  end

  def child_playables
    current_round ? [current_round] : []
  end

  def playable_action
    StartRoundPlayableAction.new(:number_of_players => players.count)
  end
end
