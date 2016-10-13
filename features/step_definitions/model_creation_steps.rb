Given(/^I have started a game with (\d+) players$/) do |player_count|
  players = Array.new(player_count) { |index| { :name => "Player #{index + 1}" } }
  Game.create! do |game|
    game.players.new(players)
  end
end

Given(/^I have started a round$/) do
  Game.last.rounds.create!(:deck_seed => 99_235)
end

Given(/^I have picked up the last cards from stock$/) do
  round = Round.last
  deck = Deck.new(:seed => round.deck_seed)
  dealer = Dealer.new(:deck => deck)

  game_engine = GameEngine.new
  game_engine.start_round(:player_names => round.game.player_names)
  game_engine.deal(:dealer => dealer)

  # Mimic playing a turns (pick up / discard) until stock is empty and
  # player is ready to discard
  game_engine.pick_up_cards
  round.player_actions << PlayerActions::PickUpCards.new
  until game_engine.stock.empty?
    card_to_discard = game_engine.active_player_hand.first
    game_engine.discard(:card => card_to_discard)
    round.player_actions << PlayerActions::Discard.new(:card_name => card_to_discard.to_s)

    game_engine.pick_up_cards
    round.player_actions << PlayerActions::PickUpCards.new
  end
end

Given(/^The round is over$/) do
  step 'I have started a round'
  step 'I have picked up the last cards from stock'
  step 'I view the round'
  step 'I discard the first card'
end

Given(/^I am playing a round with (\d+) players$/) do |player_count|
  step "I have started a game with #{player_count} players"
  step 'I have started a round'
  step 'I am viewing the round'
end

Given(/^I have melded "([^"]*)"$/) do |meld_cards|
  card_names = meld_cards.split(/, | and /)
  MeldCards.new(:round => Round.last, :card_names => card_names).call
end
