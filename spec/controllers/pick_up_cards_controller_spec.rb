require 'rails_helper'

describe PickUpCardsController, :type => :controller do
  let(:game) do
    Game.create! do |game|
      game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
    end
  end
  let(:round_id) { round.id }
  let(:params) { { :round_id => round_id } }

  describe 'POST #create' do
    context 'when picking up cards is a valid player action' do
      let(:round) { game.rounds.create!(:deck_seed => 959) }

      it 'creates a new player action' do
        expect { post :create, params }.to change(PlayerAction, :count).by(1)
      end

      it 'creates a new "pick up cards" player action' do
        post :create, params
        expect(round.player_actions.last.type).to eq PlayerActions::PickUpCards.name
      end

      it 'redirects to the current round' do
        post :create, params
        expect(response).to redirect_to round
      end
    end

    context 'when picking up cards is not a valid player action' do
      it 'redirects to the current round'
      it 'shows an error message indicating the player action was invalid'
    end
  end
end
