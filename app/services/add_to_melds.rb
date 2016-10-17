class AddToMelds
  attr_reader :round, :card_names, :meld_rank, :errors

  def initialize(round:, card_names:, meld_rank:)
    @round = round
    @card_names = card_names
    @meld_rank = meld_rank
    @errors = []
  end

  def call
    game_engine = replay_round

    # REVIEW: Transacion boundary??
    cards = card_names.map { |card_name| Card.from_s(:card_name => card_name) }
    add_to_meld(meld_rank, cards) if cards.all? { |card| game_engine.can_add_to_meld?(:meld_rank => @meld_rank, :card => card) }
    collect_game_errors(game_engine)

    no_errors?
  end

  private

  def replay_round
    replay_round_service = ReplayRound.new(:round => round)
    replay_round_service.call
  end

  def add_to_meld(meld_rank, cards)
    add_to_meld = PlayerActions::AddToMeld.new
    add_to_meld.cards << cards.map { |card| PlayerActionCard.from_card(:card => card) }
    add_to_meld.target_meld_rank = meld_rank
    round.player_actions << add_to_meld
  end

  def collect_game_errors(game_engine)
    @errors.concat(game_engine.errors)
  end

  def no_errors?
    errors.empty?
  end
end
