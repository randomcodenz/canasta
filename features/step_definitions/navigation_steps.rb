Given(/^I am on the home page$/) do
  visit root_path
end

Given(/^I am viewing the game$/) do
  visit game_path(Game.last)
end

Given(/^I am viewing the round$/) do
  visit round_path(Round.last)
end

When(/^I visit the home page$/) do
  visit root_path
end

When(/^I view the game$/) do
  visit game_path(Game.last)
end

When(/^I view the round$/) do
  visit round_path(Round.last)
end
