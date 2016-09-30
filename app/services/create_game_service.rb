class CreateGameService
  def call
    Game.create! do |new_game|
      new_game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
    end
  end
end
