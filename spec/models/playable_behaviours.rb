# Shared examples for ensuring that an implementation of playable behaves
# like a playable.
# To use:
# => require 'models/playable_behaviours' at the top of your spec file
# => call the shared examples with:
# => it_behaves_like 'a playable object' do
# =>  let(:playable) { ... create / pass the playable ... }
# => end
shared_examples 'a playable object' do
  it 'is playable' do
    expect(playable).to be_a Playable
  end

  it 'implements playable_actions or playable_action' do
    expect { playable.playable_actions }.not_to raise_error
  end

  it 'all playable_actions are PlayableAction instances' do
    playable_actions = playable.playable_actions
    expect(playable_actions).to all be_a PlayableAction
  end

  it 'root playables do not have a parent playable' do
    expect(playable.parent_playable).to be_nil if playable.root_playable?
  end

  describe '#accept' do
    let(:visitor) { double('Visitor', :visit => true) }

    it 'calls visit on the visitor passing self' do
      playable.accept(:playable_visitor => visitor)
      expect(visitor).to have_received(:visit).with(playable)
    end
  end
end
