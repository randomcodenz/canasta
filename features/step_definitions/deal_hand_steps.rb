When(/^I visit the home page$/) do
  visit root_path
end

Then(/^I should see the heading "([^"]*)"$/) do |heading|
  expect(find('h1').text).to eq heading
end

Given(/^I am on the home page$/) do
  visit root_path
end

When(/^I start a new game$/) do
  click_button('New Game')
end

Then(/^the new game is displayed$/) do
  expect(page.current_path).to eq "/games/#{Game.last.id}"
end
