Given(/^I am on the home page$/) do
  visit root_path
end

Given(/^I have started a simple game$/) do
  @game = Game.new
  @game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
  @game.save!
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
  expect(find_all('p.player').length).to eq player_count.to_i
end

Then(/^the new round is displayed$/) do
  expect(page.current_path).to eq "/games/#{Game.last.id}"
  expect(find('p#round_number').text).to eq 'Round 1'
end
