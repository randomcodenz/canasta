require 'rails_helper'
require 'models/playable_visitors/fake_playable_helper'

module PlayableVisitors
  describe ApplyActionsPlayableVisitor do
    let(:root) { FakePlayableHelper.playable_sequence(%w(root child leaf)) }
    let(:child) { root.child_playables[0] }
    let(:leaf) { child.child_playables[0] }
    let(:game_engine) { FakePlayableHelper::FakeGameEngine.new }

    subject(:apply_actions) { ApplyActionsPlayableVisitor.new(:game_engine => game_engine) }

    before { apply_actions.visit(playable) }

    context 'when given the root object' do
      let(:playable) { root }

      it 'applies all actions from root to leaf' do
        expect(game_engine).to contain_exactly(root.playable_action, child.playable_action, leaf.playable_action)
      end
    end

    context 'when given a leaf object' do
      let(:playable) { leaf }

      it 'applies the leaf action only' do
        expect(game_engine).to contain_exactly(leaf.playable_action)
      end
    end

    context 'when given an object that is neither leaf nor root' do
      let(:playable) { child }

      it 'applies all actions from child to leaf' do
        expect(game_engine).to contain_exactly(child.playable_action, leaf.playable_action)
      end
    end
  end
end
