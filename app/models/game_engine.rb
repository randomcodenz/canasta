class GameEngine
  attr_reader :errors, :number_of_players, :player_hands, :discard_pile, :stock

  def can_start_round?
    @errors = []
    @errors << 'Round has already been started' if round_started?
    no_errors?
  end

  def start_round(number_of_players:)
    @number_of_players = number_of_players if can_start_round?
    no_errors?
  end

  def can_deal?
    @errors = []
    @errors << 'Round has not been started' unless round_started?
    @errors << 'Round has already been dealt' if round_dealt?
    no_errors?
  end

  def deal(dealer:)
    if can_deal?
      the_deal = dealer.deal(:number_of_players => number_of_players)

      @player_hands = the_deal.player_hands
      @discard_pile = the_deal.discard_pile
      @stock = the_deal.stock
    end

    no_errors?
  end

  private

  def round_started?
    !number_of_players.nil?
  end

  def round_dealt?
    player_hands? || discard_pile? || stock?
  end

  def no_errors?
    errors.empty?
  end

  def player_hands?
    player_hands && player_hands.any?
  end

  def discard_pile?
    discard_pile && discard_pile.any?
  end

  def stock?
    stock && stock.any?
  end
end
