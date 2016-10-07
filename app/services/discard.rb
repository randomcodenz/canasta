class Discard
  attr_reader :round, :card_name, :errors

  def initialize(round:, card_name:)
    @round = round
    @card_name = card_name
    @errors = []
  end

  def call
    game_engine = replay_round
    card = Card.from_s(:card_name => card_name)

    discard(card) if game_engine.can_discard?(:card => card)
    collect_game_errors(game_engine)

    no_errors?
  end

  private

  def replay_round
    replay_round_service = ReplayRound.new(:round => round)
    replay_round_service.call
  end

  def discard(card)
    round.player_actions << PlayerActions::Discard.new(:card_name => card.to_s)
  end

  def collect_game_errors(game_engine)
    @errors.concat(game_engine.errors)
  end

  def no_errors?
    errors.empty?
  end
end
