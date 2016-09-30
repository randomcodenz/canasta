# Shared examples for ensuring that an implementation of playable behaves
# like a playable.
# To use:
# => require 'models/playable_behaviours' at the top of your spec file
# => call the shared examples with: it_behaves_like 'a playable object', playable
shared_examples 'a playable object' do |playable|
  it 'is playable' do
    expect(playable).to be_a Playable
  end

  it 'responds to playable_actions' do
    expect(playable).to respond_to :playable_actions
  end

  it 'all playable_actions are PlayableAction instances' do
    playable_actions = playable.playable_actions
    expect(playable_actions).to all be_a PlayableAction
  end
end
