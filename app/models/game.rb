class Game < ActiveRecord::Base
  include Playable

  has_many :players, :dependent => :destroy
  has_many :rounds, :dependent => :destroy

  def playable_actions
    [playable_action] + current_round_playable_actions
  end

  private

  def playable_action
    StartRoundPlayableAction.new(:number_of_players => players.count)
  end

  def current_round_playable_actions
    current_round ? current_round.playable_actions : []
  end

  def current_round
    # TODO : Naive implementation - needs review
    rounds.last
  end
end
