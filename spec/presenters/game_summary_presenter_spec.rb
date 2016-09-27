require 'rails_helper'

describe GameSummaryPresenter do
  describe '#round_over?' do
    let(:game) do
      Game.create! do |game|
        game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
      end
    end
    let(:presenter) { GameSummaryPresenter.new(game) }

    it 'is true when there are no rounds' do
      expect(presenter.round_over?).to be true
    end

    it 'is true when the current round does not have a score'
    it 'is false when the current round has a score'
  end
end
