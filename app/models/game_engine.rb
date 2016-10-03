class GameEngine
  attr_reader :errors, :players, :discard_pile, :stock

  def number_of_players
    players.size if players
  end

  def player_hands
    players.sort_by { |player| player.index }.map { |player| player.hand }
  end

  def current_player
    players && players[0]
  end

  def current_player_hand
    current_player.hand
  end

  def can_start_round?
    @errors = []
    @errors << 'Round has already been started' if round_started?
    no_errors?
  end

  def start_round(number_of_players:)
    if can_start_round?
      @players = Array.new(number_of_players) { |index| PlayerContext.new(:index => index) }
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
    @errors << 'Round has not been dealt' unless round_dealt?
    @errors << 'Player has already picked up' if current_player_picked_up?

    no_errors?
  end

  def pick_up_cards
    if can_pick_up_cards?
      current_player.hand += stock.shift(2)
      current_player.picked_up = true
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

  def current_player_picked_up?
    current_player ? current_player.picked_up : false
  end

  def change_current_player!
    players.rotate!
  end

  def assert_round_started
    @errors << 'Round has not been started' unless round_started?
  end
end
