class Card
  SUITS = [:spades, :hearts, :diamonds, :clubs].freeze
  RANKS = [
    :ace, :king, :queen, :jack, :ten, :nine, :eight,
    :seven, :six, :five, :four, :three, :two
  ].freeze
  JOKER = :joker

  include Comparable
  attr_reader :suit, :rank

  def initialize(args = {})
    @suit = args[:suit] || :none
    @rank = args.fetch(:rank)
  end

  def <=>(other)
    # TODO : Review approach - good / bad / ugly?
    compare_identical(other) ||
      compare_rank(other) ||
      compare_suit(other) ||
      compare_joker
  end

  private

  def compare_identical(other)
    0 if identical?(other)
  end

  def compare_rank(other)
    if same_suit?(other)
      my_rank = RANKS.find_index(rank)
      other_rank = RANKS.find_index(other.rank)
      my_rank <=> other_rank
    end
  end

  def compare_suit(other)
    if same_rank?(other)
      my_suit = SUITS.find_index(suit)
      other_suit = SUITS.find_index(other.suit)
      my_suit <=> other_suit
    end
  end

  def compare_joker
    rank == JOKER ? 1 : -1
  end

  def identical?(other)
    same_suit?(other) && same_rank?(other)
  end

  def same_suit?(other)
    suit == other.suit
  end

  def same_rank?(other)
    rank == other.rank
  end
end
