class Card
  SUITS = [:spades, :hearts, :diamonds, :clubs].freeze
  RANKS = [
    :ace, :king, :queen, :jack, :ten, :nine, :eight,
    :seven, :six, :five, :four, :three, :two
  ].freeze
  JOKER = :joker
  NO_SUIT = :none
  WILD_RANKS = [:joker, :two].freeze

  include Comparable
  attr_reader :suit, :rank

  def initialize(rank:, suit: NO_SUIT)
    raise ArgumentError, "#{rank} is not a valid rank" unless valid_rank?(rank)
    raise ArgumentError, "#{suit} is not a valid suit" unless valid_suit?(suit)

    @rank = rank
    @suit = suit
  end

  def wild?
    WILD_RANKS.include?(rank)
  end

  def natural?
    !wild?
  end

  def points
    case rank
    when :joker then 50
    when :ace, :two then 20
    when :king, :queen, :jack, :ten, :nine, :eight then 10
    else 5
    end
  end

  def <=>(other)
    compare_identical(other) ||
      compare_rank(other) ||
      compare_suit(other) ||
      compare_joker
  end

  def to_s
    if suit == :none
      rank.to_s.capitalize
    else
      "#{rank.capitalize} of #{suit.capitalize}"
    end
  end

  def self.from_s(card_name:)
    card_name_symbols = card_name.downcase.split.map(&:to_sym)

    if card_name_symbols && card_name_symbols.any?
      joker_from_symbols(card_name_symbols) || card_from_symbols(card_name_symbols)
    end
  end

  private_class_method

  def self.joker_from_symbols(card_name_symbols)
    Card.new(:rank => JOKER) if card_name_symbols.include?(JOKER)
  end

  def self.card_from_symbols(card_name_symbols)
    candidate_ranks = RANKS & card_name_symbols
    candidate_suits = SUITS & card_name_symbols

    card_rank = candidate_ranks.first if candidate_ranks.size == 1
    card_suit = candidate_suits.first if candidate_suits.size == 1

    Card.new(:rank => card_rank, :suit => card_suit) if card_rank && card_suit
  end

  private

  def valid_rank?(rank)
    rank == JOKER || RANKS.include?(rank)
  end

  def valid_suit?(suit)
    suit == NO_SUIT || SUITS.include?(suit)
  end

  def compare_identical(other)
    0 if identical?(other)
  end

  def compare_rank(other)
    unless same_rank?(other)
      my_rank = RANKS.find_index(rank)
      other_rank = RANKS.find_index(other.rank)
      my_rank <=> other_rank
    end
  end

  def compare_suit(other)
    unless same_suit?(other)
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
