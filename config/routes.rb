Rails.application.routes.draw do
  resources :theaters, except: %i[show delete]
  resources :sessions, only: %i[new create destroy]

  root to: 'movies#index'
end
