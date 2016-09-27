class Game < ActiveRecord::Base
  has_many :players, :dependent => :destroy
  has_many :rounds, :dependent => :destroy
end
