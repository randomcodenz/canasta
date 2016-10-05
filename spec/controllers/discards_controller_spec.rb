require 'rails_helper'

describe DiscardsController, :type => :controller do
  let(:game) do
    Game.create! do |game|
      game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
      game.rounds.new(:deck_seed => 959)
    end
  end
  let(:round) { game.rounds.last }
  let(:round_id) { round.id }
  let(:params) { { :round_id => round_id } }

  describe 'POST #create' do
    context 'when discarding cards is a valid player action' do
      before { round.player_actions << PlayerActions::PickUpCards.new }

      it 'creates a new player action' do
        expect { post :create, params }.to change(PlayerAction, :count).by(1)
      end

      it 'creates a new "discard" player action' do
        post :create, params
        expect(round.player_actions.last.type).to eq PlayerActions::Discard.name
      end

      it 'redirects to the current round' do
        post :create, params
        expect(response).to redirect_to round
      end
    end

    context 'when discarding is not a valid player action' do
      it 'redirects to the current round'
      it 'shows an error message indicating the player action was invalid'
    end
  end
end
