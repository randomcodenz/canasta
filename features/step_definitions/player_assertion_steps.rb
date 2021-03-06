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

Then(/^I can select multiple cards$/) do
  within('form#player_actions') do
    expect(find_all('.card input')).to all_the_things(match_xpath('//input[@type="checkbox"]'))
    expect(find_all('.card input').size).to eq find_all('.card').size
  end
end

Then(/^I can see the new meld of "([^"]*)"$/) do |meld_rank|
  meld_cards = find_all('.meld_cards').first
  expect(meld_cards.text).to have_content(meld_rank.singularize)
end

Then(/^I can see each players score$/) do
  player_scores = find_all('.player_score')
  expect(player_scores.size).to eq Game.last.players.size
end

Then(/^I can see "([^"]*)" in the "([^"]*)" meld$/) do |card_name, meld_name|
  meld_class = meld_name.downcase.singularize
  meld_cards = find(".meld_cards.#{meld_class}")
  expect(meld_cards.text).to have_content(card_name)
end
