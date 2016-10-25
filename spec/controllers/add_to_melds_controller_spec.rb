require 'rails_helper'

describe AddToMeldsController, :type => :controller do
  let(:cards_in_meld) do
    [
      PlayerActionCard.from_card(:card => Card.new(:rank => :ten, :suit => :spades)),
      PlayerActionCard.from_card(:card => Card.new(:rank => :ten, :suit => :diamonds)),
      PlayerActionCard.from_card(:card => Card.new(:rank => :ten, :suit => :hearts))
    ]
  end
  let(:game) do
    Game.create! do |game|
      game.players.new([{ :name => 'Player 1' }, { :name => 'Player 2' }])
      game.rounds.new(:deck_seed => 959) do |new_round|
        new_round.player_actions << PlayerActions::PickUpCards.new
      end
    end
  end
  let(:round) { game.rounds.last }
  let(:round_id) { round.id }
  let(:selected_cards) { ['Ten of Diamonds'] }
  let(:selected_meld) { cards_in_meld[0].rank }
  let(:params) do
    {
      :round_id => round_id,
      :player_action => { :selected_cards => selected_cards, :selected_meld => selected_meld }
    }
  end

  describe 'POST #create' do
    context 'when adding cards to a meld is a valid player action' do
      before do
        meld = PlayerActions::Meld.new do |new_meld|
          new_meld.meld_cards << cards_in_meld
        end
        round.player_actions << meld
      end

      it 'creates a new player action' do
        expect { post :create, params }.to change(PlayerAction, :count).by(1)
      end

      it 'creates a new "add to meld" player action' do
        post :create, params
        expect(round.player_actions.last.type).to eq PlayerActions::AddToMeld.name
      end

      it 'redirects to the current round' do
        post :create, params
        expect(response).to redirect_to round
      end
    end

    context 'when adding cards to a meld is not a valid player action' do
      before { post :create, params }

      it 'redirects to the current round' do
        expect(response).to redirect_to round
      end

      it 'shows an error message indicating why the meld was invalid' do
        expect(flash[:errors]).to be_present
      end
    end
  end
end
