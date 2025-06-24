Rails.application.routes.draw do
  resources :games, param: :token do
    resources :guesses, only: [:create]
  end
  root 'games#new'
end
