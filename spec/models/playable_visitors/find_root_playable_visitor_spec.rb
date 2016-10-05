require 'rails_helper'
require 'models/playable_visitors/fake_playable_helper'

module PlayableVisitors
  describe FindRootPlayableVisitor do
    let(:root) { FakePlayableHelper.playable_sequence(['root', 'first child', 'middle child', 'last child', 'leaf']) }
    let(:first_child) { root.child_playables[0] }
    let(:middle_child) { first_child.child_playables[0] }
    let(:last_child) { middle_child.child_playables[0] }
    let(:leaf) { last_child.child_playables[0] }

    subject(:find_root) { FindRootPlayableVisitor.new }

    context 'when given the root object' do
      it 'returns the root object' do
        expect(find_root.visit(root)).to be root
      end
    end

    context 'when given a leaf object' do
      it 'returns the root object' do
        expect(find_root.visit(leaf)).to be root
      end
    end

    context 'when given an object that is neither leaf nor root' do
      it 'returns the root object' do
        expect(find_root.visit(middle_child)).to be root
      end
    end
  end
end
