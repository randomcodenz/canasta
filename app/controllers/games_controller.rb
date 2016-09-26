class GamesController < ApplicationController
  # index, show, new, create, edit, update, destroy

  def index
  end

  def show
    game = Game.includes(:players).find(params[:id])
    @game = GamePresenter.new(:game => game, :game_state => deal(game))
  end

  def create
    @game = Game.new do |game|
      game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
    end
    @game.save!
    redirect_to @game
  end

  private

  def deal(game)
    current_round = game.rounds.last
    if current_round
      deck = Deck.new(:seed => current_round.deck_seed)
      dealer = Dealer.new(:deck => deck, :number_of_players => game.players.count)
      dealer.deal
    end
  end
end
