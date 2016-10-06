# REVIEW: Get rid of the Service suffix
class PickUpCardsService
  attr_reader :round, :errors

  def initialize(round:)
    @round = round
    @errors = []
  end

  def call
    game_engine = replay_round

    pick_up_cards if game_engine.can_pick_up_cards?
    collect_game_errors(game_engine)

    no_errors?
  end

  private

  def replay_round
    replay_round_service = ReplayRoundService.new(:round => round)
    replay_round_service.call
  end

  def pick_up_cards
    round.player_actions << PlayerActions::PickUpCards.new
  end

  def collect_game_errors(game_engine)
    @errors.concat(game_engine.errors)
  end

  def no_errors?
    errors.empty?
  end
end
