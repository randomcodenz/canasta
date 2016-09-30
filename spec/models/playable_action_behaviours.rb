# Shared examples for ensuring that an implementation of playable action behaves
# like a playable action.
# To use:
# => require 'models/playable_action_behaviours' at the top of your spec file
# => call the shared examples with: it_behaves_like 'a playable action', playable_action
shared_examples 'a playable action' do |playable_action|
  it 'is a playable action' do
    expect(playable_action).to be_a PlayableAction
  end

  it 'responds to apply_to' do
    expect(playable_action).to respond_to :playable_action
  end
end
