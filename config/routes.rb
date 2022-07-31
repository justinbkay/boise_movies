Rails.application.routes.draw do
  resources :theaters, except: %i[show delete]
  resources :sessions, only: %i[new create destroy]
  get "/movies/:id/trailer", to: "movies#trailer", as: "movie_trailer"

  root to: 'movies#index'
end
