# Shared examples for ensuring that an implementation of playable behaves
# like a playable.
# To use:
# => require 'models/playable_behaviours' at the top of your spec file
# => call the shared examples with: it_behaves_like 'a playable object', playable
shared_examples 'a playable object' do |playable|
  it 'is playable' do
    expect(playable).to be_a Playable
  end

  it 'responds to playable_action' do
    expect(playable).to respond_to :playable_action
  end

  it 'playable_action is a PlayableAction' do
    playable_action = playable.playable_action
    expect(playable_action).to be_a PlayableAction
  end
end
