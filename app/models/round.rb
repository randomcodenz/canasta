class Round < ActiveRecord::Base
  belongs_to :game
  validates :deck_seed, :presence => true
end
