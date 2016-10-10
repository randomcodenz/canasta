class CardRank < ActiveRecord::Base
  validates :rank,
    :presence => true,
    :length => { :maximum => 10 },
    :uniqueness => { :case_sensitive => false }

  def self.from_rank(rank:)
    where(:rank => rank.to_s).first
  end
end
