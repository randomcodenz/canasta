# Temporary holding place for the "extra" steps required for play_turn.feature
# TODO: Reorganise all steps into game creation / round creation / navigation etc
Given(/^I am viewing the round$/) do
  visit round_path(Round.last)
end

Given(/^I have picked up (?:\d+) cards from stock$/) do
  within('form#player_actions') do
    click_button('Pick up cards')
  end
end

When(/^I pick up (?:\d+) cards from stock$/) do
  within('form#player_actions') do
    click_button('Pick up cards')
  end
end

When(/^I discard a card$/) do
  within('form#player_actions') do
    first_card = find_all('li.card').first
    first_card_id = first_card.find_field('player_action[selected_cards][]')[:id]
    check(first_card_id)
    click_button('Discard')
  end
end

Then(/^I should see (\d+) cards in my hand$/) do |number_of_cards|
  player_one_cards = find_all('.player')[0].find_all('.cards .card')
  expect(player_one_cards.length).to eq number_of_cards
end

Then(/^I can see the active player is "([^"]*)"$/) do |player_name|
  expect(find('.active_player')).to have_content player_name
end
