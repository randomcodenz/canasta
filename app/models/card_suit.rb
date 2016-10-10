class CardSuit < ActiveRecord::Base
  validates :suit,
    :presence => true,
    :length => { :maximum => 10 },
    :uniqueness => { :case_sensitive => false }

  def self.from_suit(suit:)
    where(:suit => suit.to_s).first
  end
end
