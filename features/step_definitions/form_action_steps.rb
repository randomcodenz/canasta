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

When(/^I meld "([^"]*)", "([^"]*)", "([^"]*)"$/) do |card1, card2, card3|
  within('form#player_actions') do
    card_names = [card1, card2, card3]

    cards = find_all('.card').select do |card|
      card_names.any? { |card_name| card.has_content?(card_name) }
    end

    cards.each do |card|
      card_id = card.find_field('player_action[selected_cards][]')[:id]
      check(card_id)
    end

    click_button('Meld')
  end
end
