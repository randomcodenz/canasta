class PlayerAction < ActiveRecord::Base
  include Playable

  belongs_to :round
end
