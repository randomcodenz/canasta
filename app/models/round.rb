class Round < ActiveRecord::Base
  include Playable

  belongs_to :game
  has_many :player_actions, :dependent => :destroy
  validates :deck_seed, :presence => true

  def self.with_game_and_players
    includes(:game => :players)
  end

  def playable_actions
    [playable_action] + player_action_playable_actions
  end

  private

  def playable_action
    DealRoundPlayableAction.new(:deck_seed => deck_seed)
  end

  def player_action_playable_actions
    player_actions.order(:id).map { |player_action| player_action.playable_actions }.flatten
  end
end
