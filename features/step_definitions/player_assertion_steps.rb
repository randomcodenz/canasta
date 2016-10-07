Then(/^I should see (\d+) players$/) do |player_count|
  expect(find_all('.player').length).to eq player_count
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

Then(/^I should see (\d+) cards in my hand$/) do |number_of_cards|
  player_one_cards = find_all('.player')[0].find_all('.cards .card')
  expect(player_one_cards.length).to eq number_of_cards
end

Then(/^I can see the active player is "([^"]*)"$/) do |player_name|
  expect(find('.active_player')).to have_content player_name
end
