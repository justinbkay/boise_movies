Rails.application.routes.draw do
  resources :theaters, except: %i[show delete]
  root to: 'movies#index'
end
