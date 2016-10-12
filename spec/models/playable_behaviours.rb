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
end
