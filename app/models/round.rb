class Round < ActiveRecord::Base
  include Playable

  belongs_to :game
  has_many :player_actions, :dependent => :destroy
  validates :deck_seed, :presence => true

  def self.with_game_and_players
    includes(:game => :players)
  end

  def playable_action
    PlayableActions::DealRound.new(:deck_seed => deck_seed)
  end
end
