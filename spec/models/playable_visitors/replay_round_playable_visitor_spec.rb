require 'rails_helper'
require 'models/playable_visitors/fake_playable_helper'

module PlayableVisitors
  describe ReplayRoundPlayableVisitor do
    let(:root) { FakePlayableHelper.playable_sequence(%w(root child leaf)) }
    let(:child) { root.child_playables[0] }
    let(:leaf) { child.child_playables[0] }
    let(:game_engine) { FakePlayableHelper::FakeGameEngine.new }

    subject(:replay_round) { ReplayRoundPlayableVisitor.new(:game_engine => game_engine) }

    before { replay_round.visit(playable) }

    context 'when given the root object' do
      let(:playable) { root }

      it 'applies all actions from root to leaf' do
        expect(game_engine).to contain_exactly(root.playable_action, child.playable_action, leaf.playable_action)
      end
    end

    context 'when given a leaf object' do
      let(:playable) { leaf }

      it 'applies all actions from root to leaf' do
        expect(game_engine).to contain_exactly(root.playable_action, child.playable_action, leaf.playable_action)
      end
    end

    context 'when given an object that is neither leaf nor root' do
      let(:playable) { child }

      it 'applies all actions from root to leaf' do
        expect(game_engine).to contain_exactly(root.playable_action, child.playable_action, leaf.playable_action)
      end
    end
  end
end
