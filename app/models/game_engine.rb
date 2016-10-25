class GameEngine
  attr_reader :errors, :players, :discard_pile, :stock

  def round_over?
    active_player_picked_up? ? false : stock_empty?
  end

  def number_of_players
    players.size if players
  end

  def player_hands
    players.sort_by { |player| player.index }.map { |player| player.hand }
  end

  def active_player
    players && players.first
  end

  def active_player_hand
    active_player && active_player.hand
  end

  def active_player_melds
    active_player && active_player.melds
  end

  def can_start_round?
    @errors = []
    @errors << 'Round has already been started' if round_started?
    no_errors?
  end

  def start_round(player_names:)
    if can_start_round?
      @players = player_names.each_with_index.map { |name, index| PlayerContext.new(:index => index, :name => name) }
    end

    no_errors?
  end

  def can_deal?
    @errors = []

    assert_round_started
    @errors << 'Round has already been dealt' if round_dealt?

    no_errors?
  end

  def deal(dealer:)
    if can_deal?
      the_deal = dealer.deal(:number_of_players => number_of_players)

      players.zip(the_deal.player_hands).each { |player, hand| player.hand = hand }
      @discard_pile = the_deal.discard_pile
      @stock = the_deal.stock
    end
    no_errors?
  end

  def can_pick_up_cards?
    @errors = []

    assert_round_started
    assert_round_dealt
    @errors << 'Player has already picked up' if active_player_picked_up?
    assert_round_in_progress

    no_errors?
  end

  def pick_up_cards
    if can_pick_up_cards?
      active_player.hand += stock.shift(2)
      active_player.picked_up = true
    end

    no_errors?
  end

  def can_discard?(card: nil)
    @errors = []

    assert_round_started
    assert_round_dealt
    assert_player_picked_up
    assert_current_player_hand_contains_card(card) unless errors.any?

    no_errors?
  end

  def discard(card:)
    if can_discard?(:card => card)
      discard_pile << remove_card_from_active_player_hand!(card)

      change_active_player!
    end

    no_errors?
  end

  def can_meld?(cards: nil)
    @errors = []

    assert_round_started
    assert_round_dealt
    assert_player_picked_up
    assert_current_player_hand_contains_all_cards(cards) unless errors.any?
    assert_meld_valid(Meld.new(:cards => cards)) if cards && !errors.any?

    no_errors?
  end

  def meld(cards:)
    if can_meld?(:cards => cards)
      meld_cards = cards.each_with_object([]) do |card, meld|
        meld << remove_card_from_active_player_hand!(card)
      end

      active_player_melds << Meld.new(:cards => meld_cards)
    end

    no_errors?
  end

  def can_add_to_meld?(meld_rank: nil, cards: nil)
    @errors = []

    assert_round_started
    assert_round_dealt
    assert_player_picked_up
    assert_current_player_hand_contains_all_cards(cards) unless errors.any?

    meld = active_player_meld_with_rank(meld_rank)
    @errors << "Player does not have a meld of rank #{meld_rank}" if errors.empty? && cards && meld.nil?

    if meld
      meld_to_validate = Meld.new(:cards => meld.cards + cards)
      assert_meld_valid(meld_to_validate)
    end

    no_errors?
  end

  def add_to_meld(meld_rank:, cards:)
    if can_add_to_meld?(:meld_rank => meld_rank, :cards => cards)
      meld = active_player_meld_with_rank(meld_rank)
      cards.each { |card| meld.cards << remove_card_from_active_player_hand!(card) }
    end

    no_errors?
  end

  private

  def round_started?
    players && players.any?
  end

  def round_dealt?
    player_hands_dealt? || discard_pile? || stock?
  end

  def no_errors?
    errors.empty?
  end

  def player_hands_dealt?
    players && players.any? { |player| player.hand && player.hand.any? }
  end

  def discard_pile?
    discard_pile && discard_pile.any?
  end

  def stock?
    stock && stock.any?
  end

  def stock_empty?
    stock && stock.empty?
  end

  def active_player_picked_up?
    active_player ? active_player.picked_up : false
  end

  def active_player_hand_contains?(card)
    active_player_hand && active_player_hand.include?(card)
  end

  def active_player_meld_with_rank(rank)
    if active_player_melds
      active_player_melds.select do |meld|
        meld.rank == rank
      end.first
    end
  end

  def change_active_player!
    players.rotate!
    reset_player_flags(players.last)
  end

  def reset_player_flags(player)
    player.picked_up = false
  end

  def remove_card_from_active_player_hand!(card)
    # Only want the first instance of the card that matches
    card_index = active_player_hand.index(card)
    active_player_hand.delete_at(card_index)
  end

  def assert_round_started
    @errors << 'Round has not been started' unless round_started?
  end

  def assert_round_dealt
    @errors << 'Round has not been dealt' unless round_dealt?
  end

  def assert_player_picked_up
    @errors << 'Player has not picked up' unless active_player_picked_up?
  end

  def assert_current_player_hand_contains_card(card)
    @errors << "Hand does not include #{card}" unless card.nil? || active_player_hand_contains?(card)
  end

  def assert_current_player_hand_contains_all_cards(cards)
    cards ||= []
    cards.each { |card| assert_current_player_hand_contains_card(card) }
  end

  def assert_round_in_progress
    @errors << 'Round has ended' if round_over?
  end

  def assert_meld_valid(meld)
    assert_meld_big_enough(meld)
    assert_meld_with_cards_of_the_same_rank(meld)
    assert_meld_with_more_natural_cards_than_wild(meld)
    assert_meld_with_three_wild_cards_max(meld)
  end

  def assert_meld_big_enough(meld)
    @errors << "A meld must consist of three cards minimum" if meld.cards.size < 3
  end

  def assert_meld_with_cards_of_the_same_rank(meld)
    @errors << "Cards in meld must be of the same rank" if meld.cards.select(&:natural?).map(&:rank).uniq.size > 1
  end

  def assert_meld_with_more_natural_cards_than_wild(meld)
    @errors << "A meld must contain more natural cards than wild" if meld.cards.select(&:wild?).size >= meld.cards.select(&:natural?).size
  end

  def assert_meld_with_three_wild_cards_max(meld)
    @errors << "A meld must contain three wild cards maximum" if meld.cards.select(&:wild?).size > 3
  end
end
