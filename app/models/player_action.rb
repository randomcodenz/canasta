class PlayerAction < ActiveRecord::Base
  include Playable

  belongs_to :round

  def parent_playable
    round
  end
end
