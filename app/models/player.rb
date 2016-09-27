class Player < ActiveRecord::Base
  belongs_to :game
  validates :name,
    :presence => true,
    :length => { :maximum => 50 },
    :uniqueness => { :case_sensitive => false, :scope => :game_id }
end
