Rails.application.routes.draw do
  root 'games#index'

  resources :games, :only => [:index, :show, :create] do
    resources :rounds, :only => [:show, :create]
  end
end
