Rails.application.routes.draw do
  resources :games do
    resources :guesses, only: [:create]
  end
  root 'games#new'
end
