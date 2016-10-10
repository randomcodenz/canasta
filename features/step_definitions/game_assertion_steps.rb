Then(/^I should see the heading "([^"]*)"$/) do |heading|
  expect(find('h1').text).to eq heading
end

Then(/^the new game is displayed$/) do
  expect(page.current_path).to eq "/games/#{Game.last.id}"
end

Then(/^I can see Round (\d+)$/) do |round_number|
  expect(page.current_path).to eq "/rounds/#{Round.last.id}"
  expect(find('#round_number').text).to eq "Round #{round_number}"
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

Then(/^I can see the round is over$/) do
  expect(page).to have_css('#round_over')
end
