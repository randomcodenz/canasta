Rails.application.routes.draw do
  root 'games#index'

  resources :games, :only => [:index, :show, :create] do
    resources :rounds, :only => [:create]
  end

  resources :rounds, :only => [:show] do
    resource :pick_up_cards, :only => [:create]
    resource :discards, :only => [:create]
    resource :meld_cards, :only => [:create]
    resource :add_to_meld, :only => [:create]
  end
end
