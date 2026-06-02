Rails.application.routes.draw do
  resources :games, param: :token do
    resources :guesses, only: [:create]
    resources :hints, only: [:create]
  end
  root 'games#new'
end
