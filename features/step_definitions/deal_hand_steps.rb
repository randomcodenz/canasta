Transform(/^(-?\d+)$/) do |number|
  number.to_i
end

Given(/^I am on the home page$/) do
  visit root_path
end

Given(/^I have started a game with (\d+) players$/) do |player_count|
  players = Array.new(player_count) { |index| { :name => "Player #{index + 1}" } }
  Game.create! do |game|
    game.players.new(players)
  end
end

Given(/^I have started a round$/) do
  Game.last.rounds.create!(:deck_seed => 99_235)
end

Given(/^I am viewing the game$/) do
  visit game_path(Game.last)
end

When(/^I visit the home page$/) do
  visit root_path
end

When(/^I start a new game$/) do
  click_button('New Game')
end

When(/^I view the game$/) do
  visit game_path(Game.last)
end

When(/^I view the round$/) do
  visit round_path(Round.last)
end

When(/^I start a new round$/) do
  click_button('Start round')
end

Then(/^I should see the heading "([^"]*)"$/) do |heading|
  expect(find('h1').text).to eq heading
end

Then(/^the new game is displayed$/) do
  expect(page.current_path).to eq "/games/#{Game.last.id}"
end

Then(/^I should see (\d+) players$/) do |player_count|
  expect(find_all('.player').length).to eq player_count
end

Then(/^I can see Round (\d+)$/) do |round_number|
  expect(page.current_path).to eq "/rounds/#{Round.last.id}"
  expect(find('#round_number').text).to eq "Round #{round_number}"
end

Then(/^I should see (\d+) players cards$/) do |player_count|
  expect(find_all('.player .cards').length).to eq player_count
end

Then(/^I should see (\d+) cards per player$/) do |cards_per_player|
  player_card_counts = find_all('.player .cards').map do |cards|
    cards.find_all('.card').length
  end
  expect(player_card_counts).to all_the_things(eq cards_per_player)
end
Then(/^I should see the top card of the discard pile$/) do
  expect(find('#discard_pile').text).to include 'Five of Hearts'
end

Then(/^I should see the discard pile contains (\d+) (card|cards)$/) do |number_of_cards, card_or_cards|
  expect(find('#discard_pile').text).to include "(#{number_of_cards} #{card_or_cards})"
end

Then(/^I should see the stock$/) do
  expect(find('#stock').text).to include 'Stock'
end

Then(/^I should see the stock contains (\d+) (card|cards)$/) do |number_of_cards, card_or_cards|
  expect(find('#stock').text).to include "(#{number_of_cards} #{card_or_cards})"
end
