Given(/^I have picked up (?:\d+) cards from stock$/) do
  within('form#player_actions') do
    click_button('Pick up cards')
  end
end

When(/^I start a new game$/) do
  click_button('New Game')
end

When(/^I start a new round$/) do
  click_button('Start round')
end

When(/^I pick up (?:\d+) cards from stock$/) do
  within('form#player_actions') do
    click_button('Pick up cards')
  end
end

When(/^I discard the first card$/) do
  within('form#player_actions') do
    first_card = find_all('li.card').first
    first_card_id = first_card.find_field('player_action[selected_cards][]')[:id]
    check(first_card_id)
    click_button('Discard')
  end
end
