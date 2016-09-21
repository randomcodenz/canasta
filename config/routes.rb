Rails.application.routes.draw do
  root 'games#index'

  resources :games, :only => [:index, :create, :show] do
    resources :rounds, :only => [:create]
  end
end
