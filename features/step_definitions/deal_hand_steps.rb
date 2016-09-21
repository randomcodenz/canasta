When(/^I visit the home page$/) do
  visit root_path
end

Then(/^I should see the heading "([^"]*)"$/) do |heading|
  expect(find('h1').text).to eq heading
end
