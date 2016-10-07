Given(/^I have started a game with (\d+) players$/) do |player_count|
  players = Array.new(player_count) { |index| { :name => "Player #{index + 1}" } }
  Game.create! do |game|
    game.players.new(players)
  end
end

Given(/^I have started a round$/) do
  Game.last.rounds.create!(:deck_seed => 99_235)
end
