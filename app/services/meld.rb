class Meld
  attr_reader :round, :card_names, :errors

  def initialize(round:, card_names:)
    @round = round
    @card_names = card_names
    @errors = []
  end

  def call
    game_engine = replay_round

    cards = card_names.map { |card_name| Card.from_s(:card_name => card_name) }
    meld_cards(cards) if game_engine.can_meld?(:cards => cards)
    collect_game_errors(game_engine)

    no_errors?
  end

  private

  def replay_round
    replay_round_service = ReplayRound.new(:round => round)
    replay_round_service.call
  end

  def meld_cards(cards)
    meld = PlayerActions::Meld.new
    meld.meld_cards << cards.map { |card| PlayerActionCard.from_card(:card => card) }
    round.player_actions << meld
  end

  def collect_game_errors(game_engine)
    @errors.concat(game_engine.errors)
  end

  def no_errors?
    errors.empty?
  end
end
